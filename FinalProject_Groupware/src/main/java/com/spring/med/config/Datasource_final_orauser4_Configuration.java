package com.spring.med.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement 
@MapperScan(basePackages={"com.spring.med.organization.model","com.spring.med.approval.model"}, sqlSessionFactoryRef="sqlSessionFactory")
public class Datasource_final_orauser4_Configuration {

	@Value("${mybatis.mapper-locations}")  // *.yml 파일에 있는 설정값 내 mapper 파일의 위치를 알려주는 것이다.
    private String mapperLocations;
	
	@Bean
	@Qualifier("dataSource")
    @ConfigurationProperties(prefix = "spring.datasource-finalorauser4") 
    public DataSource dataSource(){
        return DataSourceBuilder.create().build();
    }
	
	
    @Bean
    @Qualifier("sqlSessionFactory")
    @Primary	
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource, ApplicationContext applicationContext) throws Exception{ 
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        sqlSessionFactoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis/mybatis-config.xml")); 
        sqlSessionFactoryBean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(mapperLocations));

        return sqlSessionFactoryBean.getObject();

    }


    @Bean
    @Qualifier("sqlsession")
    @Primary
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("sqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
   
    
    @Bean 
    public PlatformTransactionManager transactionManager_final_orauser4() {
        DataSourceTransactionManager tm = new DataSourceTransactionManager();
        tm.setDataSource(dataSource());
        return tm;
    }
    
	
}
