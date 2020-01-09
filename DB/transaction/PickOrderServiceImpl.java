

/**
 * @date 创建日期：20191121
 */
@CacheConfig(cacheNames = "pickOrder")
@Service(interfaceClass = PickOrderService.class, group = "gift")
public class PickOrderServiceImpl extends BaseServiceImpl<PickOrder, PickOrderMapper> implements PickOrderService {

    @Autowired
    private PickOrderUserGoodsService pickOrderUserGoodsService;
    @Autowired
    private UserGoodsService userGoodsService;
    @Autowired
    private GiveOrderService giveOrderService;
    @Autowired
    private BuyGoodsService buyGoodsService;

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = JoinusException.class)
    @Override
    public Map<String, Object> addPickOrder(PickOrderVo vo, Long userId) throws JoinusException {
        Map<String, Object> result = new HashMap<>();
        BigDecimal goodsTotalAmount = vo.getGoodsTotalAmount();
        Boolean isFreightFree = vo.getFreightFree();
        Long addrId = vo.getAddrId();
        String remark = vo.getRemark();
        List<UntreatedGoodsPo> goods = vo.getGoods();
        Assert.isTrue(DataUtils.isNotEmpty(isFreightFree) && isFreightFree &&
                goodsTotalAmount.compareTo(new BigDecimal(THRESHOLD_FREIGHT_FREE)) > 0, "当前提货请求是免运费提货！");
        Assert.isTrue(DataUtils.isNotEmpty(addrId), "收货地址id不能为空！");
        Assert.isTrue(DataUtils.isNotEmpty(goods), "提货礼品不能为空！");
        Assert.isTrue(DataUtils.isNotEmpty(goodsTotalAmount), "提货总金额不能为空！");
        Assert.isTrue(DataUtils.isNotEmpty(userId), "用户ID不能为空！");
        List<Long> userGoodsIdList = goods.stream().map(UntreatedGoodsPo::getUserGoodsId).collect(Collectors.toList());
        Integer count = userGoodsService.countPickedGoodsByIds(userGoodsIdList);
        Assert.isTrue(Objects.equals(count, 0), "已选中礼品包含不可提货的礼品");
        Assert.isTrue(goodsTotalAmount.compareTo(BigDecimal.ZERO) > 0, "提货礼品总金额错误！");
        List<String> list2 = userGoodsIdList.stream().map(Object::toString).collect(Collectors.toList());
        try {
            //提货现单表
            PickOrder pickOrder = new PickOrder();
            if (vo.getFreightFree()) {
                //SUMMARY 免运费提货单
                pickOrder.setPickOrderNo(PREFIX_PICK_ORDER + OmnipotentUtils.createOrderNo());
                pickOrder.setTotalAmount(goodsTotalAmount);
                pickOrder.setUserGoodsIds(String.join(",", list2).concat(","));
                pickOrder.setAddrId(addrId);
                pickOrder.setState(OrderState.SUCCESS_WITHOUT_PAY);
                pickOrder.setRemark(remark);
                pickOrder.setCreateTime(LocalDateTime.now());
                pickOrder.setUpdateTime(LocalDateTime.now());
                mapper.insert(pickOrder);
                //提货单礼品关系表
                List<PickOrderUserGoods> list = new ArrayList<>();
                goods.forEach(g -> {
                    PickOrderUserGoods poug = new PickOrderUserGoods();
                    poug.setPickOrderNo(pickOrder.getPickOrderNo());
                    poug.setGoodsSerialNo(g.getGoodsSerialNo());
                    poug.setUserGoodsId(g.getUserGoodsId());
                    poug.setCreateTime(LocalDateTime.now());
                    poug.setUpdateTime(LocalDateTime.now());
                    list.add(poug);
                });
                pickOrderUserGoodsService.batchInsertOrderGoodsRelation(list);
                //更新用户礼品关系状态
                userGoodsService.updateStateByUserGoodsId(STATE_USER_GOODS_PICKED, userGoodsIdList);
                if (DataUtils.isNotEmpty(pickOrder.getPickOrderNo())) {
                    result.put("pickOrderNo", pickOrder.getPickOrderNo());
                } else {
                    result.put("pickOrderNo", -1L);
                }
            }
        } catch (JoinusException e) {
            e.printStackTrace();
            throw new JoinusException("Error_新增礼品提货单异常");
        }
        return result;
    }



}
