package team.gtfm.server.db;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import team.gtfm.server.bean.Pc;
import team.gtfm.server.bean.Switch;

@Repository
public class PcDao {
	@Autowired
	private SqlSessionFactoryBean factory;
	
	public List<Pc> selectPcAll(){
		try(SqlSession sqlSession = factory.newSqlSession()){
			return sqlSession.selectList("team.gtfm.server.db.pcMapper.selectPcAll");
		}
	}
	
	public Pc selectPc(int seq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			return sqlSession.selectOne("team.gtfm.server.db.pcMapper.selectPc", map);
		}
	}
		
	public int insertPc(Pc pc){
		try(SqlSession sqlSession = factory.newSqlSession()){
			int c = sqlSession.insert("team.gtfm.server.db.pcMapper.insertPc", pc);
			sqlSession.commit();
			return c;
		}
	}
		
	public int deletePc(int seq){
		try(SqlSession sqlSession = factory.newSqlSession()){
			Map<String, Object> map = new HashMap<>();
			map.put("seq", seq);
			int c = sqlSession.delete("team.gtfm.server.db.pcMapper.deletePc", map);
			sqlSession.commit();
			return c;
		}
	}
}
