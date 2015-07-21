package team.gtfm.server.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import team.gtfm.server.bean.Switch;

@Repository
public class SwitchDao {
	@Autowired
	private SqlSessionFactoryBean factory;
	
	public List<Switch> selectSwitchAll(){
		try(SqlSession sqlSession = factory.newSqlSession()){
			return sqlSession.selectList("team.gtfm.server.db.switchMapper.selectSwitchAll");
		}
	}
	
	public Switch selectSwitch(int seq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			return sqlSession.selectOne("team.gtfm.server.db.switchMapper.selectSwitch", map);
		}
	}
		
	public int insertSwitch(Switch newSwitch){
		try(SqlSession sqlSession = factory.newSqlSession()){
			int c = sqlSession.insert("team.gtfm.server.db.switchMapper.insertSwitch", newSwitch);
			sqlSession.commit();
			return c;
		}
	}
		
	public int deleteSwitch(int seq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			int c = sqlSession.delete("team.gtfm.server.db.switchMapper.deleteSwitch", map);
			sqlSession.commit();
			return c;
		}
	}
}
