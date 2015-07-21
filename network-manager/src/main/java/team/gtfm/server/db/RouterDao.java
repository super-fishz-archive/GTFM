package team.gtfm.server.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import team.gtfm.server.bean.Router;
import team.gtfm.server.bean.RouterStatus;

@Repository
public class RouterDao {
	@Autowired
	private SqlSessionFactoryBean factory;
	
	public List<Router> selectRouterAll(){
		try(SqlSession sqlSession = factory.newSqlSession()){
			return sqlSession.selectList("team.gtfm.server.db.routerMapper.selectRouterALl");
		}
	}
	
	public Router selectRouter(int seq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			return sqlSession.selectOne("team.gtfm.server.db.routerMapper.selectRouter", map);
		}
	}
	
	public int insertRouter(Router router){
		try(SqlSession sqlSession = factory.newSqlSession()){
			int c = sqlSession.insert("team.gtfm.server.db.routerMapper.insertRouter", router);
			sqlSession.commit();
			return c;
		}
	}
	
	public int deleteRouter(int seq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			int c = sqlSession.delete("team.gtfm.server.db.routerMapper.deleteRouter", map);
			sqlSession.commit();
			return c;
		}
	}
	
	public List<RouterStatus> selectRouterInBuilding(int buildingSeq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("buildingSeq", buildingSeq);
			return sqlSession.selectList("team.gtfm.server.db.routerMapper.selectRouterInBuilding", map);
		}
	}
}
