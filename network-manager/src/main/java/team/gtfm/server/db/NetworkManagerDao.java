package team.gtfm.server.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import team.gtfm.server.bean.Building;
import team.gtfm.server.bean.Port;

@Repository
public class NetworkManagerDao {
	@Autowired
	SqlSessionFactoryBean sqlSessionFactoryBean;
	
	public List<Port> selectNotUsingIpPort(){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			List<Port> list = sqlSession.selectList("team.gtfm.server.db.ipMapper.notUsingIp");
			return list;
		}
	}
	
	public int insertPort(Port port){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			int c = sqlSession.insert("team.gtfm.server.db.ipMapper.insertPort", port);
			sqlSession.commit();
			
			return c;
		}
	}
	
	public List<Port> selectPortAll(){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			return sqlSession.selectList("team.gtfm.server.db.ipMapper.selectPortAll");
		}
	}
	
	public int deletePort(int seq){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			int c = sqlSession.delete("team.gtfm.server.db.ipMapper.deletePort", map);
			sqlSession.commit();
			
			return c;
		}
	}
	
	public List<Building> selectBuildingAll(){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			return sqlSession.selectList("team.gtfm.server.db.buildingMapper.selectBuildingAll");
		}
	}
	
	public Building selectBuilding(int seq){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			return sqlSession.selectOne("team.gtfm.server.db.buildingMapper.selectBuilding", map);
		}
	}
	
	public int deleteBuilding(int seq){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			int c = sqlSession.delete("team.gtfm.server.db.buildingMapper.deleteBuilding", map);
			sqlSession.commit();
			return c;
		}
	}
	
	public int insertBuilding(Building building){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			int c = sqlSession.insert("team.gtfm.server.db.buildingMapper.insertBuilding", building);
			sqlSession.commit();
			return c;
		}
	}
	
	
}
