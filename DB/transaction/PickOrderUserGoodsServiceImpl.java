

/**
 * @date 创建日期：20191119
 */
@CacheConfig(cacheNames = "pickOrderUserGood")
@Service(interfaceClass = PickOrderUserGoodsService.class, group = "gift")
public class PickOrderUserGoodsServiceImpl extends BaseServiceImpl<PickOrderUserGoods, PickOrderUserGoodsMapper> implements PickOrderUserGoodsService {

    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = JoinusException.class)
    @Override
    public void batchInsertOrderGoodsRelation(List<PickOrderUserGoods> list) throws JoinusException {
        try {
            mapper.batchInsertOrderGoodsRelation(list);
        } catch (JoinusException e) {
            e.printStackTrace();
            throw new JoinusException("Error_批量插入提货单礼品关系异常");
        }
    }
}
