/*
 * Created on Nov 22, 2004
 *
 * Last modified on Nov 22, 2004
 */
package org.lamsfoundation.lams.usermanagement.service;

import java.util.List;
import org.lamsfoundation.lams.usermanagement.dao.IUserDAO;
import org.lamsfoundation.lams.usermanagement.dao.IRoleDAO;
import org.lamsfoundation.lams.usermanagement.dao.IOrganisationDAO;
import org.lamsfoundation.lams.usermanagement.dao.IOrganisationTypeDAO;
import org.lamsfoundation.lams.usermanagement.dao.IUserOrganisationDAO;
import org.lamsfoundation.lams.usermanagement.dao.IUserOrganisationRoleDAO;
import org.lamsfoundation.lams.usermanagement.dao.IAuthenticationMethodDAO;
import org.lamsfoundation.lams.usermanagement.User;
import org.lamsfoundation.lams.usermanagement.Role;
import org.lamsfoundation.lams.usermanagement.Organisation;
import org.lamsfoundation.lams.usermanagement.OrganisationType;
import org.lamsfoundation.lams.usermanagement.UserOrganisation;
import org.lamsfoundation.lams.usermanagement.UserOrganisationRole;
import org.lamsfoundation.lams.usermanagement.AuthenticationMethod;

/**
 * User Management Service Interface to handle communication between 
 * web and persistence layer.
 * 
 * <p>
 * <a href="IUserManagementService.java.html"><i>View Source</i></a>
 * </p>
 * 
 * @author <a href="mailto:fyang@melcoe.mq.edu.au">Fei Yang</a>
 */
public interface IUserManagementService {

    /**
     * Set IUserDAO
     *
     * @param userDao
     */
	public void setUserDAO(IUserDAO userDao);

    /**
     * Set IRoleDAO
     *
     * @param roleDao
     */
	public void setRoleDAO(IRoleDAO roleDao);
	
    /**
     * Set IOrganisationDAO
     *
     * @param organisationDao 
     */
	public void setOrganisationDAO(IOrganisationDAO organisationDao);

    /**
     * Set IOrganisationTypeDAO
     *
     * @param organisationTypeDao 
     */
	public void setOrganisationTypeDAO(IOrganisationTypeDAO organisationTypeDao);
	
	
    /**
     * Set IUserOrganisationDAO
     *
     * @param organisationDao 
     */
	public void setUserOrganisationDAO(IUserOrganisationDAO userOrganisationDao);

    /**
     * Set IUserOrganisationRoleDAO
     *
     * @param organisationRoleDao 
     */
	public void setUserOrganisationRoleDAO(IUserOrganisationRoleDAO userOrganisationRoleDao);
	
    /**
     * Set IAuthenticationMethodDAO
     *
     * @param authenticationMethodDao
     */
	public void setAuthenticationMethodDAO(IAuthenticationMethodDAO authenticationMethodDao);

	/**
     * Retrieves a user by userId.  null will be returned 
     * if no user with the userId is found
     * 
     * @param userId the user's userId
     * @return User
     */
    public User getUserById(Integer userId);

    
	/**
     * Retrieves a user by login.  null will be returned 
     * if no user with the login is found
     * 
     * @param login the user's login
     * @return User
     */
    public User getUserByLogin(String login);

	/**
     * Retrieves a organisation by id.  null will be returned 
     * if no organisation with the id is found
     * 
     * @param organisationId the organisation's id
     * @return Organisation
     */
    public Organisation getOrganisationById(Integer organisationId);

	/**
     * Retrieves a organisationType by name.  null will be returned 
     * if no organisationType with the id is found
     * 
     * @param name the organisation type's name
     * @return OrganisationType
     */
    public OrganisationType getOrganisationTypeByName(String name);
    
	/**
     * Retrieves a role by name.  null will be returned 
     * if no role with the name is found
     * 
     * @param roleName role's name
     * @return Role
     */
    public Role getRoleByName(String roleName);
    
	/**
     * Retrieves a userOrganisationRole by ids and name.  null will be returned 
     * if no userOrganisationRole is found
     * 
     * @param login the user's login
     * @param organisationId the organisation's id
     * @param roleName the role's name
     * @return UserOrganisationRole
     */
    public UserOrganisationRole getUserOrganisationRole(String login,Integer organisationId,String roleName);

	/**
     * Retrieves a userOrganisation by login and id.  null will be returned 
     * if no userOrganisation is found
     * 
     * @param userId the user's Id
     * @param organisationId the organisation's id
     * @return UserOrganisation
     */
    public UserOrganisation getUserOrganisation(Integer userId,Integer organisationId);
    
    
	/**
     * Retrieves organisations in which the user 
     * has the specified role 
     * 
     * @param user the user
     * @param roleName role's name
     * @return List of organisations
     */
    public List getOrganisationsForUserByRole(User user, String roleName);

	/**
     * Retrieves child organisations of the parentOrg 
     * 
     * @param parentOrg the parent organisation
     * @return List of organisations
     */
    public List getChildOrganisations(Organisation parentOrg);
    
	/**
     * Retrieves userOrganisations for the user 
     * 
     * @param user the user
     * @return List of organisations
     */
    public List getUserOrganisationsForUser(User user);

    
	/**
     * Retrieves the base organisation
     * 
     * @param organisation the organisation
     * @return Base Organisation of the organisation specified by the
     * 			parameter
     */
    public Organisation getBaseOrganisation(Organisation organisation);
    
	/**
     * Retrieves roles in which the user 
     * has the specified role 
     * 
     * @param user the user
     * @param orgId organisation's id
     * @return List of roles
     */
    public List getRolesForUserByOrganisation(User user, Integer orgId);

	/**
     * Retrieves users from the specified organisation
     * 
     * @param orgId organisation's id
     * @return List of users
     */
    public List getUsersFromOrganisation(Integer orgId);
    
    /**
     * Retrieves All the AuthenticationMethods 
     * 
     * @return List of AuthenticationMethods
     */
    public List getAllAuthenticationMethods();

    /**
     * Retrieves AuthenticationMethod for the user
     * specified by login
     * 
     * @param login the user's login
     * @return AuthenticationMethod for this user
     */
    public AuthenticationMethod getAuthenticationMethodForUser(String login);

    /**
     * Retrieves AuthenticationMethod 
     * specified by name
     * 
     * @param name the method's name
     * @return AuthenticationMethod with the name
     */
    public AuthenticationMethod getAuthenticationMethodByName(String name);
   
    /**
     * Creates a user
     * 
     * @param user the user to be created
     */
    public void createUser(User user);

    /**
     * Updates a user's information
     *
     * @param user the user
     */
    public void updateUser(User user);

    /**
     * Save or Updates a user's information
     *
     * @param user the user
     */
    public void saveOrUpdateUser(User user);

    /**
     * Updates user's password
     * @param login the user's login
     * @param newPassword the user's new password
     */
    public void updatePassword(String login, String newPassword);    
    
    /**
     * Removes a user from the organisation
     *
     * @param userOrganisation the user's memebership in the organisation
     */
    public void removeUserOrganisation(UserOrganisation userOrganisation);
    
    /**
     * Saves or updates an organisation
     * 
     * @param organisation the organisation to be saved or updated
     */
    public void saveOrUpdateOrganisation(Organisation organisation);
    
    /**
     * Saves or updates an userOrganisation
     * 
     * @param userOrganisation the userOrganisation to be saved or updated
     */
    public void saveOrUpdateUserOrganisation(UserOrganisation userOrganisation);

    /**
     * Saves or updates an userOrganisationRole
     * 
     * @param userOrganisationRole the userOrganisationRole to be saved or updated
     */
    public void saveOrUpdateUserOrganisationRole(UserOrganisationRole userOrganisationRole);
    
}
