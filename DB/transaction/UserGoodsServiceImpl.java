

/**
 * @date 2019/11/18  16:48
 */
@CacheConfig(cacheNames = "userGoods")
@Service(interfaceClass = UserGoodsService.class, group = "gift")
public class UserGoodsServiceImpl extends BaseServiceImpl<UserGoods, UserGoodsMapper> implements UserGoodsService {


    @Transactional(propagation = Propagation.REQUIRED, rollbackFor = JoinusException.class)
    @Override
    public void updateStateByUserGoodsId(Integer state, List<Long> list) throws JoinusException {
        try {
            mapper.updateStateByUserGoodsId(state, list);
        } catch (JoinusException e) {
            e.printStackTrace();
            throw new JoinusException("Error_更新用户礼品关系状态异常");
        }
    }

}
