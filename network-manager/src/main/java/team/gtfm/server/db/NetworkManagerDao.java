package team.gtfm.server.db;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NetworkManagerDao {
	@Autowired
	SqlSessionFactoryBean sqlSessionFactoryBean;
}
