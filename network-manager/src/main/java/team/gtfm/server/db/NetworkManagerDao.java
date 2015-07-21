package team.gtfm.server.db;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NetworkManagerDao {
	@Autowired
	SqlSessionFactoryBean sqlSessionFactoryBean;
	
	public List<String> test(){
		try(SqlSession sqlSession = sqlSessionFactoryBean.newSqlSession()){
			List<String> list = sqlSession.selectList("team.gtfm.server.db.ipMapper.notUsingIp");
			return list;
		}
	}
}
