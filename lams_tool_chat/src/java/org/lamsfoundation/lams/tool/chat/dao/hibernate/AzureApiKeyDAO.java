package org.lamsfoundation.lams.tool.chat.dao.hibernate;

import java.util.List;
import org.hibernate.SessionFactory;
import org.hibernate.query.Query;
import org.lamsfoundation.lams.dao.hibernate.LAMSBaseDAO;
import org.lamsfoundation.lams.tool.chat.dao.IAzureApiKeyDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

/**
 * @author mafeng
 * @version 1.0
 * @description
 * @date 2023/7/25 16:17
 */
@Repository
public class AzureApiKeyDAO extends LAMSBaseDAO implements IAzureApiKeyDAO {

    @Autowired
    @Qualifier("coreSessionFactory")
    private SessionFactory sessionFactory;

    private static final String GET_API_KEY = "select config_value from lams_configuration where config_key = 'AzureOpenApiKey'";

    @Override
    public String getApiKey() {
        Query queryObject = getSession().createSQLQuery(GET_API_KEY);
        return (String)queryObject.getSingleResult();
    }
}
