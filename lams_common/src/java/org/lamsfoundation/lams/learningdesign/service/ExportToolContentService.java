/****************************************************************
 * Copyright (C) 2005 LAMS Foundation (http://lamsfoundation.org)
 * =============================================================
 * License Information: http://lamsfoundation.org/licensing/lams/2.0/
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2.0 
 * as published by the Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301
 * USA
 * 
 * http://www.gnu.org/licenses/gpl.txt
 * ****************************************************************
 */

/* $Id$ */
package org.lamsfoundation.lams.learningdesign.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.log4j.Logger;
import org.jdom.Attribute;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.Namespace;
import org.jdom.input.SAXBuilder;
import org.jdom.output.XMLOutputter;
import org.lamsfoundation.lams.contentrepository.ItemNotFoundException;
import org.lamsfoundation.lams.contentrepository.NodeKey;
import org.lamsfoundation.lams.contentrepository.RepositoryCheckedException;
import org.lamsfoundation.lams.contentrepository.client.IToolContentHandler;
import org.lamsfoundation.lams.dao.IBaseDAO;
import org.lamsfoundation.lams.learningdesign.Activity;
import org.lamsfoundation.lams.learningdesign.ActivityOrderComparator;
import org.lamsfoundation.lams.learningdesign.ChosenGrouping;
import org.lamsfoundation.lams.learningdesign.ComplexActivity;
import org.lamsfoundation.lams.learningdesign.Grouping;
import org.lamsfoundation.lams.learningdesign.GroupingActivity;
import org.lamsfoundation.lams.learningdesign.LearningDesign;
import org.lamsfoundation.lams.learningdesign.License;
import org.lamsfoundation.lams.learningdesign.OptionsActivity;
import org.lamsfoundation.lams.learningdesign.ParallelActivity;
import org.lamsfoundation.lams.learningdesign.PermissionGateActivity;
import org.lamsfoundation.lams.learningdesign.RandomGrouping;
import org.lamsfoundation.lams.learningdesign.ScheduleGateActivity;
import org.lamsfoundation.lams.learningdesign.SequenceActivity;
import org.lamsfoundation.lams.learningdesign.SynchGateActivity;
import org.lamsfoundation.lams.learningdesign.ToolActivity;
import org.lamsfoundation.lams.learningdesign.Transition;
import org.lamsfoundation.lams.learningdesign.dao.IActivityDAO;
import org.lamsfoundation.lams.learningdesign.dao.IGroupingDAO;
import org.lamsfoundation.lams.learningdesign.dao.ILearningDesignDAO;
import org.lamsfoundation.lams.learningdesign.dao.ILearningLibraryDAO;
import org.lamsfoundation.lams.learningdesign.dao.ILicenseDAO;
import org.lamsfoundation.lams.learningdesign.dao.ITransitionDAO;
import org.lamsfoundation.lams.learningdesign.dto.AuthoringActivityDTO;
import org.lamsfoundation.lams.learningdesign.dto.GroupingDTO;
import org.lamsfoundation.lams.learningdesign.dto.LearningDesignDTO;
import org.lamsfoundation.lams.learningdesign.dto.TransitionDTO;
import org.lamsfoundation.lams.lesson.LessonClass;
import org.lamsfoundation.lams.tool.SystemTool;
import org.lamsfoundation.lams.tool.Tool;
import org.lamsfoundation.lams.tool.ToolContent;
import org.lamsfoundation.lams.tool.ToolContentManager;
import org.lamsfoundation.lams.tool.dao.ISystemToolDAO;
import org.lamsfoundation.lams.tool.dao.IToolContentDAO;
import org.lamsfoundation.lams.tool.dao.IToolDAO;
import org.lamsfoundation.lams.tool.dao.IToolImportSupportDAO;
import org.lamsfoundation.lams.tool.exception.ToolException;
import org.lamsfoundation.lams.usermanagement.User;
import org.lamsfoundation.lams.usermanagement.WorkspaceFolder;
import org.lamsfoundation.lams.util.Configuration;
import org.lamsfoundation.lams.util.ConfigurationKeys;
import org.lamsfoundation.lams.util.FileUtil;
import org.lamsfoundation.lams.util.FileUtilException;
import org.lamsfoundation.lams.util.MessageService;
import org.lamsfoundation.lams.util.zipfile.ZipFileUtil;
import org.lamsfoundation.lams.util.zipfile.ZipFileUtilException;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.NoSuchBeanDefinitionException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.converters.Converter;
/**
 * Export tool content service bean.
 * @author Steve.Ni
 * 
 * @version $Revision$
 */
public class ExportToolContentService implements IExportToolContentService, ApplicationContextAware {
	private static final int PACKAGE_FORMAT_IMS = 2;
	
	public static final String LEARNING_DESIGN_SERVICE_BEAN_NAME = "learningDesignService";
	public static final String MESSAGE_SERVICE_BEAN_NAME = "commonMessageService";
	public static final String LD102IMPORTER_BEAN_NAME = "ld102Importer";
	
	//export tool content zip file prefix
	public static final String EXPORT_TOOLCONTNET_ZIP_PREFIX = "lams_toolcontent_";
	public static final String EXPORT_LDCONTENT_ZIP_PREFIX = "lams_ldcontent_";
	public static final String EXPORT_TOOLCONTNET_FOLDER_SUFFIX = "export_toolcontent";
	public static final String EXPORT_TOOLCONTNET_ZIP_SUFFIX = ".zip";
	public static final String EXPORT_LDCONTENT_ZIP_SUFFIX = ".zip";
	public static final String LEARNING_DESIGN_FILE_NAME = "learning_design.xml";
	private static final String LEARNING_DESIGN_IMS_FILE_NAME = "imsmanifest.xml";
	public static final String TOOL_FILE_NAME = "tool.xml";
	public static final String TOOL_FAILED_FILE_NAME = "export_failed.xml";
	
	private static final String ERROR_TOOL_NOT_FOUND = "error.import.matching.tool.not.found";
	private static final String ERROR_SERVICE_ERROR = "error.import.tool.service.fail";
	private static final String ERROR_NO_VALID_TOOL = "error.no.valid.tool";
	private static final String FILTER_METHOD_PREFIX_DOWN = "down";
	private static final String FILTER_METHOD_PREFIX_UP = "up";
	private static final String FILTER_METHOD_MIDDLE = "To";
	
	//IMS format some tag name
	private static final String IMS_FILE_NAME_EXT = "_imsld";
	private static final String IMS_TAG_RESOURCES = "resources";
	private static final String IMS_TAG_RESOURCE = "resource";
	private static final String IMS_ATTR_IDENTIFIER = "identifier";
	private static final String IMS_TAG_FILE = "file";
	private static final String IMS_ATTR_HREF = "href";
	private static final String IMS_ATTR_REF = "ref";

	private static final String IMS_PREFIX_RESOURCE_IDENTIFIER = "R-";
	private static final String IMS_PREFIX_ACTIVITY_REF = "A-";

		//this is not IMS standard tag, temporarily use to gather all tools node list
	private static final String IMS_TAG_TRANSITIONS = "transitions";

	// this is not IMS standard tag, temp use to ref grouping/gate activities 
	private static final String IMS_TAG_GROUPING = "group";
	private static final String IMS_TAG_GATE = "gate";
	
	//temporarily file for IMS XSLT file
	private static final String XSLT_PARAM_RESOURCE_FILE = "resourcesFile";
	private static final String IMS_RESOURCES_FILE_NAME = "resources.xml";
	private static final String XSLT_PARAM_TRANSITION_FILE = "transitionsFile";
	private static final String IMS_TRANSITION_FILE_NAME = "transitions.xml";

	private static final String IMS_TOOL_NS_PREFIX = "http://www.lamsfoundation/xsd/lams_tool_";

	private static final String IMS_TAG_LEARING_ACTIIVTY_REF = "learning-activity-ref";

	private static final String IMS_TOOL_MAIN_OBJECT = "mainObject";

	//2 dirs for zip file and temporary IMS XSLT
	private static final String DIR_CONTENT = "content";
	private static final String DIR_XSLT_TEMP = "xslttmp";

	//files name of IMS SCHEMA
	private static final String SCHEMA_FILE_IMSCP = "imscp_v1p1.xsd";
	private static final String SCHEMA_FILE_IMS_LD_LEVEL_A = "IMS_LD_Level_A.xsd";
	private static final String SCHEMA_FILE_IMS_LD_LEVEL_B = "IMS_LD_Level_B.xsd";
	private static final String SCHEMA_FILE_IMS_LD_LEVEL_C = "IMS_LD_Level_C.xsd";
	
	//Other fields
	private Logger log = Logger.getLogger(ExportToolContentService.class);
	
	private static MessageService messageService;
	private ApplicationContext applicationContext;
	
	//save list of all tool file node class information. One tool may have over one file node, such as 
	//in share resource tool, it has contnent attachment and shared resource item attachement. 
	private List<NameInfo> fileHandleClassList;
	private Class filterClass; 
	
	//spring injection properties
	private IActivityDAO activityDAO;
	private IToolDAO toolDAO;
	private IToolContentDAO toolContentDAO;
	private ISystemToolDAO systemToolDAO;
	private IBaseDAO baseDAO;
	private ILicenseDAO licenseDAO;
	private IGroupingDAO groupingDAO;
	private ITransitionDAO  transitionDAO;
	private ILearningDesignDAO learningDesignDAO;
	private ILearningLibraryDAO learningLibraryDAO;
	private IToolImportSupportDAO toolImportSupportDAO;
	
	/**
	 * Class of tool attachment file handler class and relative fields information container.
	 */
	private class NameInfo{
		
	
		//the Class instance according to className.
		public String className;
		public String uuidFieldName;
		public String versionFieldName;
		public String fileNameFieldName;
		public String mimeTypeFieldName;
		public String filePropertyFieldName;
		public String initalItemFieldName;
		
		public NameInfo(String className, String uuidFieldName, String versionFieldName){
			this.className = className;
			this.uuidFieldName = uuidFieldName;
			this.versionFieldName = versionFieldName;
		}
		public NameInfo(String className, String uuidFieldName, String versionFieldName,
				String fileNameFieldName, String filePropertyFieldName,String mimeTypeFieldName, 
				String initalItemFieldName) {
			this.className = className;
			this.uuidFieldName = uuidFieldName;
			this.versionFieldName = versionFieldName;
			this.fileNameFieldName = fileNameFieldName;
			this.filePropertyFieldName = filePropertyFieldName;
			this.mimeTypeFieldName = mimeTypeFieldName;
			this.initalItemFieldName = initalItemFieldName;
		}
	}
	
	/**
	 * File node value information container. 
	 */
	private class ValueInfo{
		//for unmarshal
		public NameInfo name;
		public Object instance;
		
		//for marshal
		public Long fileUuid;
		public Long fileVersionId;
		
		public ValueInfo(NameInfo name, Object instance){
			this.name = name;
			this.instance = instance;
		}
		
		public ValueInfo(Long uuid, Long versionId){
			this.fileUuid = uuid;
			this.fileVersionId = versionId;
		}
	}
	/**
	 * Proxy class for Default XStream converter.
	 *  
	 */
	private class FileInvocationHandler implements InvocationHandler{
		
		private Object obj;
		private List<ValueInfo> fileNodes;
		private List<NameInfo> fileHandleClassList;
		public FileInvocationHandler(Object obj){
			this.obj = obj;
			this.fileNodes = new ArrayList<ValueInfo>();
		}
		public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
			Object result;
			try {
		    	//for export : marshal object to xml  
			    if(StringUtils.equals(method.getName(),"marshal")){
			    	for(NameInfo name:fileHandleClassList){
				    	if(args[0] != null && name.className.equals((args[0].getClass().getName()))){
							Long uuid = NumberUtils.createLong(BeanUtils.getProperty(args[0],name.uuidFieldName));
							if(uuid != null){
								//version id is optional
								Long version = null;
								if(name.versionFieldName != null)
									version = NumberUtils.createLong(BeanUtils.getProperty(args[0],name.versionFieldName));
								log.debug("XStream get file node ["+uuid +"," + version +"].");
								fileNodes.add(ExportToolContentService.this.new ValueInfo(uuid,version));
							}
				    	}
			    	}
			    }

			    if(StringUtils.equals(method.getName(),"canConvert")){
			    	boolean canConvert = false;
			    	for(NameInfo info:fileHandleClassList){
				    	if(args[0] != null && info.className.equals(((Class)args[0]).getName())){
				    		log.debug("XStream will handle ["+info.className+"] as file node class.");
				    		canConvert = true;
				    		break;
				    	}
			    	}
			    	return canConvert;
			    }
			    
			    result = method.invoke(obj, args);
			    
//			  for import : unmarshal xml to object
			    if(StringUtils.equals(method.getName(),"unmarshal") && result != null){
			    	//During deserialize XML file into object, it will save file node into fileNodes
			    	for(NameInfo name:fileHandleClassList){
			    		if(name.className.equals(result.getClass().getName())){
			    			fileNodes.add(ExportToolContentService.this.new ValueInfo(name,result));
			    			break;
			    		}
			    	}
			    }
	        } catch (InvocationTargetException e) {
	        	throw e.getTargetException();
	        }
		        
			return result;
		}

		public List<ValueInfo> getFileNodes() {
			return fileNodes;
		}
		public List<NameInfo> getFileHandleClassList() {
			return fileHandleClassList;
		}
		public void setFileHandleClassList(List<NameInfo> fileHandleClassList) {
			this.fileHandleClassList = fileHandleClassList;
		}
	}
	/**
	 * This class is just for later system extent tool compaiblity strategy use. Currently, it just
	 * simple to get tool by same signature.
	 * 
	 * @author Steve.Ni
	 * 
	 * @version $Revision$
	 */
	public class ToolCompatibleStrategy{
		public Tool getTool(String toolSignature){
			return toolDAO.getToolBySignature(toolSignature);
		}
	}
	/**
	 * Default contructor method.
	 */
	public ExportToolContentService(){
		fileHandleClassList = new ArrayList<NameInfo>();
	}
	/**
	 * @see org.lamsfoundation.lams.authoring.service.IExportToolContentService.exportLearningDesign(Long)
	 */
	public String exportLearningDesign(Long learningDesignId, List<String> toolsErrorMsgs,int format,File xslt) throws ExportToolContentException{
		try {
			//root temp directory, put target zip file
			String targetZipFileName = null;
			String rootDir = FileUtil.createTempDirectory(EXPORT_TOOLCONTNET_FOLDER_SUFFIX);
			String contentDir = FileUtil.getFullPath(rootDir,DIR_CONTENT);
			FileUtil.createDirectory(contentDir);
			
			//this folder put all IMS XSLT transform temporary files, so try to keep content is clean for final package!
			//The reason use temporary folder instead of delete temporary files from content folder is, sometimes, delete file does not work well
			//this makes the final zip file should contain some rubbish files.
			String xsltTempDir = FileUtil.getFullPath(rootDir, DIR_XSLT_TEMP);
			if(format == PACKAGE_FORMAT_IMS){
				FileUtil.createDirectory(xsltTempDir);
			}
			//learing design file name with full path
			String ldFileName;
			if(format == PACKAGE_FORMAT_IMS)
				ldFileName = FileUtil.getFullPath(xsltTempDir,LEARNING_DESIGN_FILE_NAME);
			else
				ldFileName = FileUtil.getFullPath(contentDir,LEARNING_DESIGN_FILE_NAME);
			Writer ldFile = new OutputStreamWriter(new FileOutputStream(ldFileName),"UTF-8"); 
			
			//get learning desing and serialize it to XML file.
			ILearningDesignService service =  getLearningDesignService();
			LearningDesignDTO ldDto = service.getLearningDesignDTO(learningDesignId);
			ldDto.setTitle(ldDto.getTitle().concat(IMS_FILE_NAME_EXT));
			XStream designXml = new XStream();
			designXml.toXML(ldDto,ldFile);
			ldFile.close();
			
			log.debug("Learning design xml export success");
			
			//iterator all activities in this learning design and export their content to given folder.
			//The content will contain tool.xml and attachment files of tools from LAMS repository.
			List<AuthoringActivityDTO> activities = ldDto.getActivities();
			
			//create resources Dom node list for IMS package.
			List<Element> resChildren = new ArrayList<Element>();
			
			//iterator all activities and export tool.xml and its attachments 
			for(AuthoringActivityDTO activity : activities){
				
				//skip non-tool activities
				if(activity.getActivityTypeID().intValue() != Activity.TOOL_ACTIVITY_TYPE)
					continue;
				
				//find out current acitivites toolContentMananger and export tool content.
				ToolContentManager contentManager = (ToolContentManager) findToolService(toolDAO.getToolByID(activity.getToolID()));
				log.debug("Tool export content : " + activity.getActivityTitle() +" by contentID :" + activity.getToolContentID());
				try{
					contentManager.exportToolContent(activity.getToolContentID(),contentDir);
				}catch (Exception e) {
					String msg = activity.getToolDisplayName() + " export tool content failed:" + e.toString();
					log.error(msg);
					//Try to delete tool.xml. This makes export_failed and tool.xml does not exist simultaneously.
					String toolPath = FileUtil.getFullPath(contentDir,activity.getToolContentID().toString());
					String toolFileName = FileUtil.getFullPath(toolPath,TOOL_FILE_NAME);
					File toolFile = new File(toolFileName);
					if(toolFile.exists())
						toolFile.delete();
					writeErrorToToolFile(contentDir,activity.getToolContentID(),msg);
					toolsErrorMsgs.add(msg);
				} 
				
				//create resource node list for this activity
				if(format == PACKAGE_FORMAT_IMS){
					handleIMS(rootDir, activity,resChildren);
				}
			} //end all acitivites export
			
			try {
				//handle IMS format
				if(format == PACKAGE_FORMAT_IMS){
					transformIMS(resChildren,rootDir,ldDto,xslt);
				}

				//create zip file for fckeditor unique content folder
				String targetContentZipFileName = EXPORT_LDCONTENT_ZIP_PREFIX + ldDto.getContentFolderID() + EXPORT_LDCONTENT_ZIP_SUFFIX;
				String secureDir = Configuration.get(ConfigurationKeys.LAMS_EAR_DIR) + File.separator + FileUtil.LAMS_WWW_DIR + File.separator + FileUtil.LAMS_WWW_SECURE_DIR;
				String ldContentDir = FileUtil.getFullPath(secureDir,ldDto.getContentFolderID());
				
				if(FileUtil.directoryExist(ldContentDir)) {
					log.debug("Create export Learning Design content target zip file. File name is " + targetContentZipFileName);
					ZipFileUtil.createZipFile(targetContentZipFileName, ldContentDir, contentDir);
				} else {
					log.error("No such directory:" + ldContentDir);
				}
				
			} catch (Exception e) {
				log.error("Exception:" + e.toString());
				throw new ExportToolContentException(e);
			}
			
			// zip file name with full path
			targetZipFileName = URLEncoder.encode(ldDto.getTitle() + EXPORT_TOOLCONTNET_ZIP_SUFFIX, "UTF-8");
			
			log.debug("Create export content target zip file. File name is " + targetZipFileName);
			//create zip file and return zip full file name
			return ZipFileUtil.createZipFile(targetZipFileName, contentDir,rootDir);
		} catch (FileUtilException e) {
			log.error("FileUtilExcpetion:" + e.toString());
			throw new ExportToolContentException(e);
		} catch (ZipFileUtilException e) {
			log.error("ZipFileUtilException:" + e.toString());
			throw new ExportToolContentException(e);
		} catch (IOException e) {
			log.error("IOException:" + e.toString());
			throw new ExportToolContentException(e);
		}
	}
	/**
	 * Generate temporary files:  resources.xml and transitions.xml. <BR>
	 * Transform LAMS format learning_design.xml with resources.xml and transitions.xml into ims_learning_design.xml file.
	 * @param resChildren
	 * @param rootDir
	 * @param ldDto
	 * @throws Exception
	 */
	private void transformIMS(List<Element> resChildren, String rootDir,LearningDesignDTO ldDto,File xsltIn) throws Exception {
		String contentDir = FileUtil.getFullPath(rootDir, DIR_CONTENT);
		String xsltDir = FileUtil.getFullPath(rootDir, DIR_XSLT_TEMP);
		
		String ldFileName = FileUtil.getFullPath(xsltDir,LEARNING_DESIGN_FILE_NAME);
		//copy XSLT file to contentDir, so that the XSLT document() function does not need absolute path file.
		File xslt = new File(FileUtil.getFullPath(xsltDir, "ims.xslt"));
		FileUtil.copyFile(xsltIn, xslt);
		
		//copy schema files to content folder
		String path = FileUtil.getFileDirectory(xsltIn.getCanonicalPath());
		File imscpSrc = new File(FileUtil.getFullPath(path,SCHEMA_FILE_IMSCP));
		File imsldaSrc = new File(FileUtil.getFullPath(path,SCHEMA_FILE_IMS_LD_LEVEL_A));
		File imsldbSrc = new File(FileUtil.getFullPath(path,SCHEMA_FILE_IMS_LD_LEVEL_B));
		File imsldcSrc = new File(FileUtil.getFullPath(path,SCHEMA_FILE_IMS_LD_LEVEL_C));
		File imscpTar = new File(FileUtil.getFullPath(contentDir,SCHEMA_FILE_IMSCP));
		File imsldaTar = new File(FileUtil.getFullPath(contentDir,SCHEMA_FILE_IMS_LD_LEVEL_A));
		File imsldbTar = new File(FileUtil.getFullPath(contentDir,SCHEMA_FILE_IMS_LD_LEVEL_B));
		File imsldcTar = new File(FileUtil.getFullPath(contentDir,SCHEMA_FILE_IMS_LD_LEVEL_C));
		FileUtil.copyFile(imscpSrc, imscpTar);
		FileUtil.copyFile(imsldaSrc, imsldaTar);
		FileUtil.copyFile(imsldbSrc, imsldbTar);
		FileUtil.copyFile(imsldcSrc, imsldcTar);
		
		//create resources.xml file
		Document resourcesDom = new Document();
		Element resRoot = new Element(IMS_TAG_RESOURCES);
		resRoot.setChildren(resChildren);
		resourcesDom.setRootElement(resRoot);
		File resFile = new File(FileUtil.getFullPath(xsltDir,IMS_RESOURCES_FILE_NAME));
		XMLOutputter resOutput = new XMLOutputter();
		resOutput.output(resourcesDom, new FileOutputStream(resFile));
		
		log.debug("Export IMS: Resources file generated sucessfully:" + resFile.getAbsolutePath());
		
		//create transitions Dom node list for IMS package
		Document transDom = new Document();
		Element transRoot = new Element(IMS_TAG_TRANSITIONS);
		List<Element> transChildren = new ArrayList<Element>();
		//create transitions DOM file
		List<AuthoringActivityDTO> sortedActList = getSortedActivities(ldDto);
		//remove activities inside complex activities, the IMS package does not need that.
		//I don't want to disturb getSortedActivities() method, so that I removed them here.
		Iterator<AuthoringActivityDTO> iter = sortedActList.iterator();
		while(iter.hasNext()){
			AuthoringActivityDTO activityDTO = iter.next();
			if(activityDTO.getParentActivityID() != null)
				iter.remove();
			if(activityDTO.getActivityTypeID() == Activity.SEQUENCE_ACTIVITY_TYPE
				|| activityDTO.getActivityTypeID() == Activity.PARALLEL_ACTIVITY_TYPE
				|| activityDTO.getActivityTypeID() == Activity.OPTIONS_ACTIVITY_TYPE)
				iter.remove();
		}
		
		for (AuthoringActivityDTO actDto : sortedActList) {
			log.debug("Export IMS: Put actitivies " + actDto.getActivityTitle() + "[" +actDto.getToolContentID()+"] into Transition <learning-activity-ref> tag.");
			Element ref = new Element(IMS_TAG_LEARING_ACTIIVTY_REF);
			Attribute att = null;
			
			//
			if(actDto.getActivityTypeID().equals(Activity.GROUPING_ACTIVITY_TYPE))
				att = new Attribute(IMS_ATTR_REF,IMS_PREFIX_ACTIVITY_REF + IMS_TAG_GROUPING + "-" + actDto.getActivityID());
			else if(actDto.getActivityTypeID().equals(Activity.SCHEDULE_GATE_ACTIVITY_TYPE) || actDto.getActivityTypeID().equals(Activity.PERMISSION_GATE_ACTIVITY_TYPE)
													  || actDto.getActivityTypeID().equals(Activity.SYNCH_GATE_ACTIVITY_TYPE))
				att = new Attribute(IMS_ATTR_REF,IMS_PREFIX_ACTIVITY_REF + IMS_TAG_GATE + "-" + actDto.getActivityID());
			else 
				att = new Attribute(IMS_ATTR_REF,IMS_PREFIX_ACTIVITY_REF +  actDto.getToolSignature() + "-" + actDto.getToolContentID());
			
			ref.setAttribute(att);
			transChildren.add(ref);
		}
		transRoot.setChildren(transChildren);
		transDom.setRootElement(transRoot);
		File transFile = new File(FileUtil.getFullPath(xsltDir,IMS_TRANSITION_FILE_NAME));
		XMLOutputter transOutput = new XMLOutputter();
		transOutput.output(transDom, new FileOutputStream(transFile));
		log.debug("Export IMS: Transtion(<learning-activity-ref>) file generated sucess: " + transFile.getAbsolutePath());
		
		//call XSLT to create ims XML file
		//put parameters: transitions and resources file name
		Map<String, Object> params = new HashMap<String, Object>();
		params.put(XSLT_PARAM_RESOURCE_FILE, IMS_RESOURCES_FILE_NAME);
		params.put(XSLT_PARAM_TRANSITION_FILE, IMS_TRANSITION_FILE_NAME);
		
		//transform
		log.debug("Export IMS: Starting transform IMS XML by XSLT...");
		Document odoc = transform(new FileInputStream(new File(ldFileName)), xslt,params);
		
		log.debug("Export IMS: Transform IMS XML by XSLT sucess.");
		//output IMS format LD XML
		String imsLdFileName = FileUtil.getFullPath(contentDir,LEARNING_DESIGN_IMS_FILE_NAME);
		XMLOutputter output = new XMLOutputter();
		output.output(odoc, new FileOutputStream(new File(imsLdFileName)));
		
		log.debug("Export IMS: IMS XML is saved sucessfully.");

		
	}
	
	/**
	 * This quite complex method will return a sorted acitivityDTO list according to current LD DTO.
	 * <BR>
	 * It considers the broken LD situation. A frist activity will always be first one, but others brokend sequence in this LD 
	 * sorted by randomly. In one brokend seuqence, all acitivities will sorted by transition.   
	 * <BR>
	 * The reason to use lots "for" is Activity DTO does not contain next transition information. It has to be iterator all transtions or activities.
	 *  
	 * @param ldDto
	 * @return
	 */
	private List<AuthoringActivityDTO> getSortedActivities(LearningDesignDTO ldDto) {
		List<TransitionDTO> sortedList = new ArrayList<TransitionDTO>();
		List<AuthoringActivityDTO> sortedActList = new ArrayList<AuthoringActivityDTO>();
		List<TransitionDTO> transList = ldDto.getTransitions();
		
		Long firstActId = ldDto.getFirstActivityID();
		List<AuthoringActivityDTO> activities =ldDto.getActivities();
		
		//put first activity into sorted list
		for (AuthoringActivityDTO activityDTO : activities) {
			if(activityDTO.getActivityID().equals(firstActId)){
				sortedActList.add(activityDTO);
				break;
			}
		}
		List<Long> firstActList = new ArrayList<Long>();
		
		//try find a sorted transition list.
		if(transList != null){
			Long actId = firstActId;
			firstActList.add(actId);
			
			for(int idx=0;idx< 5000;idx++){
				boolean find = false;
				//iterator all transition to find next activity
				for (TransitionDTO transitionDTO : transList) {
					if(transitionDTO.getFromActivityID().equals(actId)){
						//achieve this sequence end
						sortedList.add(transitionDTO);
						actId = transitionDTO.getToActivityID();
						
						//put next activity inot sorted list
						for (AuthoringActivityDTO activityDTO : activities) {
							if(activityDTO.getActivityID().equals(actId)){
								sortedActList.add(activityDTO);
								break;
							}
						}
						find = true;
						break;
					}
				}
				
				if(actId == null || transList.size() == sortedList.size())
					break;
				
				//already achieve one sequence end, but it still exist unsorted transition, it means
				//this ld is broken one, there are at least two "first act" (there is no "transition to") 
				if(!find){
					for (AuthoringActivityDTO act: activities) {
						boolean isFirst = true;
						for (TransitionDTO tranDto : transList) {
							//there is some transtion to this act, it is not "head activity" then skip this act.
							if(tranDto.getToActivityID().equals(act.getActivityID())){
								isFirst = false;
								break;
							}
						}
						//if it is "head activity" and it has not been used
						if(isFirst && !firstActList.contains(act.getActivityID())){
							firstActList.add(actId);
							actId = act.getActivityID();
							//put next activity inot sorted list
							for (AuthoringActivityDTO activityDTO : activities) {
								if(activityDTO.getActivityID().equals(actId)){
									sortedActList.add(activityDTO);
									break;
								}
							}
							break;
						}
					}
				} //end find another "head activity"
			} 
		}

		//there are some sole activities exist in this LD,append them into sorted list end.
		if(sortedActList.size() < activities.size()){
			for (AuthoringActivityDTO activityDTO : activities){
				boolean exist = false;
				for (AuthoringActivityDTO sortedAct : sortedActList) {
					if(sortedAct.getActivityID().equals(activityDTO.getActivityID())){
						exist  = true;
						break;
					}
				}
				if(!exist)
					sortedActList.add(activityDTO);
				
				if(sortedActList.size() == activities.size())
					break;
			}
		}
		return sortedActList;
	}
	/**
	 * Move LAMS tool.xml from tool folder to export content root folder and modify it to {toolContentID}.xml file. Cache all attachement files
	 * from this tool into ArrayList, which will be save into a temporary file (resources.xml) and used by XSLT. 
	 * 
	 * @param rootDir
	 * @param activity
	 * @param resChildren
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	private void handleIMS(String rootDir, AuthoringActivityDTO activity, List<Element> resChildren) throws IOException, FileNotFoundException {
		String contentDir = FileUtil.getFullPath(rootDir, DIR_CONTENT);
		String xsltDir = FileUtil.getFullPath(rootDir, DIR_XSLT_TEMP);
		
		String toolPath = FileUtil.getFullPath(contentDir,activity.getToolContentID().toString());
		File toolDir = new File(toolPath);
		if(toolDir != null){
			String[] allfiles = toolDir.list();
			for (String filename: allfiles) {
				//handle tool.xml file if it is
				if(StringUtils.equals(filename, TOOL_FILE_NAME)){
					String toolFileName = FileUtil.getFullPath(toolPath,TOOL_FILE_NAME);
					File toolFile = new File(toolFileName);
					SAXBuilder sax = new SAXBuilder();
					try {
						log.debug("Export IMS: Start transforming tool.xml in " + activity.getActivityTitle() + "[" +activity.getToolContentID()+"]");
						
						Document doc = sax.build(new FileInputStream(toolFile));
						Element root = doc.getRootElement();
						//cache DTO object class and transform it into a tag : for later import use by XStream.
						String mainObject = root.getName();
						root.setName(activity.getToolSignature());
						Namespace ns = Namespace.getNamespace(IMS_TOOL_NS_PREFIX+activity.getToolSignature()+"_ims_" + activity.getToolVersion() + ".xsd");
						root.setNamespace(ns);
						
						//add mainObject tag: it save the Tool DTO class name. It is useful when importing by XStream (perhaps a future function) 
						Element mainObjectEle = new Element(IMS_TOOL_MAIN_OBJECT);
						mainObjectEle.setText(mainObject);
						root.addContent(mainObjectEle);
						
						//create a new tools.xml file with toolContentID.xml as name.
						File imsToolFile = new File(FileUtil.getFullPath(xsltDir,activity.getToolContentID().toString()+".xml"));
						XMLOutputter toolOutput = new XMLOutputter();
						toolOutput.output(doc, new FileOutputStream(imsToolFile));
						
						log.debug("Export IMS: Tool.xml in " + activity.getActivityTitle() + "[" +activity.getToolContentID()+"] transform success.");
					} catch (JDOMException e) {
						log.error("IMS export occurs error when reading tool xml for " + toolFileName + ".");
					}
					//tool node already gather into LD root folder imstools.xml file, delete old tool.xml from tool folder
					toolFile.delete();
					continue;
				}
				
				//handle other attachment files from tools, treat them as resource of IMS package
				List<Element> fileChildren = new ArrayList<Element>();
				//resource TAG
				Element resEle = new Element(IMS_TAG_RESOURCE);
				//the resource identifier should be "R_toolSignature_toolContentId"
				Attribute resAtt = new Attribute(IMS_ATTR_IDENTIFIER,IMS_PREFIX_RESOURCE_IDENTIFIER+ activity.getToolSignature()+"-" + activity.getToolContentID().toString());
				resEle.setAttribute(resAtt);
				
				//file TAG
				Element fileEle = new Element(IMS_TAG_FILE);
				Attribute fileAtt = new Attribute(IMS_ATTR_HREF,activity.getToolContentID()+"/" + filename);
				fileEle.setAttribute(fileAtt);
				
				log.debug("Export IMS: Cache resource file "+ filename + " under " + activity.getActivityTitle() + "[" +activity.getToolContentID()+"] into resources XML node");
				//build relations of TAGS
				fileChildren.add(fileEle);
				resEle.setChildren(fileChildren);
				resChildren.add(resEle);
				
			}
		}
	}

	/**
	 * @throws ExportToolContentException 
	 * 
	 */
	public void exportToolContent(Long toolContentId, Object toolContentObj, IToolContentHandler toolContentHandler, String rootPath) 
				throws ExportToolContentException {
		try {
			//create tool's save path
			String toolPath = FileUtil.getFullPath(rootPath,toolContentId.toString());
			FileUtil.createDirectory(toolPath);
			
			//create tool xml file name : tool.xml
			String toolFileName = FileUtil.getFullPath(toolPath,TOOL_FILE_NAME);
			Writer toolFile = new OutputStreamWriter(new FileOutputStream(toolFileName),"UTF-8");
			
			//serialize tool xml into local file.
			XStream toolXml = new XStream();
			//get back Xstream default convert, create proxy then register it to XStream parser.
			Converter c = toolXml.getConverterLookup().defaultConverter();
			FileInvocationHandler handler =null;
			if(!fileHandleClassList.isEmpty()){
				handler = new FileInvocationHandler(c);
				handler.setFileHandleClassList(fileHandleClassList);
				Converter  myc = (Converter) Proxy.newProxyInstance(c.getClass().getClassLoader(),new Class[]{Converter.class},handler);
				toolXml.registerConverter(myc);
			}
			//XML to Object
			toolXml.toXML(toolContentObj,toolFile);
			toolFile.flush();
			toolFile.close();
			
			//get out the fileNodes
			if(handler != null){
				List<ValueInfo> list = handler.getFileNodes();
				for(ValueInfo fileNode:list){
					log.debug("Tool attachement file is going to save : " + fileNode.fileUuid);
					toolContentHandler.saveFile(fileNode.fileUuid,FileUtil.getFullPath(toolPath,fileNode.fileUuid.toString()));
				}
				list.clear();
			}
		} catch (ItemNotFoundException e) {
			throw new ExportToolContentException(e);
		} catch (RepositoryCheckedException e) {
			throw new ExportToolContentException(e);
		} catch (IOException e) {
			throw new ExportToolContentException(e);
		} catch (FileUtilException e) {
			throw new ExportToolContentException(e);
		} finally{
			if(fileHandleClassList != null)
				fileHandleClassList.clear();
		}
		
	}
	
	/**
	 * @see org.lamsfoundation.lams.authoring.service.IExportToolContentService.registerFileHandleClass(String,String,String)
	 */
	public void registerFileClassForExport(String fileNodeClassName,String fileUuidFieldName, String fileVersionFieldName){
		fileHandleClassList.add(this.new NameInfo(fileNodeClassName,fileUuidFieldName,fileVersionFieldName));
	}
	public void registerFileClassForImport(String fileNodeClassName, String fileUuidFieldName,
			String fileVersionFieldName, String fileNameFieldName, String filePropertyFieldName, String mimeTypeFieldName,
			String initialItemFieldName) {
		fileHandleClassList.add(this.new NameInfo(fileNodeClassName, fileUuidFieldName, fileVersionFieldName,
				fileNameFieldName, filePropertyFieldName, mimeTypeFieldName, initialItemFieldName));
	}
	public void registerImportVersionFilterClass(Class filterClass) {
		this.filterClass = filterClass;
	}

	/**
	 * Import 1.0.2 learning design 
	 * @return learningDesingID
	 * @throws ExportToolContentException 
	 * @see org.lamsfoundation.lams.authoring.service.IExportToolContentService.importLearningDesign102(String, User, WorkspaceFolder)
	 */
	public Long importLearningDesign102(String ldWddxPacket, User importer, Integer workspaceFolderUid
			, List<String> toolsErrorMsgs) throws ImportToolContentException {
		WorkspaceFolder folder = getWorkspaceFolderForDesign(importer, workspaceFolderUid);
    	LD102Importer oldImporter = getLD102Importer();
    	return oldImporter.storeLDDataWDDX(ldWddxPacket, importer, folder, toolsErrorMsgs);
	}
	

	/**
	 * @return learningDesingID
	 * @throws ExportToolContentException 
	 * @see org.lamsfoundation.lams.authoring.service.IExportToolContentService.importLearningDesign(String)
	 */
	public Long importLearningDesign(String learningDesignPath, User importer, Integer workspaceFolderUid
			, List<String> toolsErrorMsgs) throws ImportToolContentException {
		
		try {
			//import learning design
			Reader ldFile = new InputStreamReader(new FileInputStream(FileUtil.getFullPath(learningDesignPath,LEARNING_DESIGN_FILE_NAME)),"UTF-8"); 
			XStream designXml = new XStream();
			LearningDesignDTO ldDto = (LearningDesignDTO) designXml.fromXML(ldFile);
			
			log.debug("Learning design xml deserialize to LearingDesignDTO success.");
	
			//begin tool import
			Map<Long,ToolContent> toolMapper = new HashMap<Long,ToolContent>();
			Map<Long,AuthoringActivityDTO> removedActMap = new HashMap<Long,AuthoringActivityDTO>();
			List<AuthoringActivityDTO> activities = ldDto.getActivities();
			for(AuthoringActivityDTO activity : activities){
				//skip non-tool activities
				if(activity.getActivityTypeID().intValue() != Activity.TOOL_ACTIVITY_TYPE)
					continue;
				
				String toolPath = FileUtil.getFullPath(learningDesignPath,activity.getToolContentID().toString());
				
				//To create a new toolContent according to imported tool signature name.
				//get tool by signature
				Tool newTool = new ToolCompatibleStrategy().getTool(activity.getToolSignature());
				
				//can not find a matching tool
				if(newTool == null){
					log.warn("An activity can not found matching tool [" + activity.getToolSignature()+"].");
					toolsErrorMsgs.add(getMessageService().getMessage(ERROR_TOOL_NOT_FOUND,new Object[]{activity.getToolSignature()}));
					
					//remove this activity from LD
					removedActMap.put(activity.getActivityID(), activity);
					continue;
				}
				//save Tool into lams_tool table.
				ToolContent newContent = new ToolContent(newTool);
			    toolContentDAO.saveToolContent(newContent);
			    
				//put new toolContent and it is old toolContentID into 
				toolMapper.put(activity.getToolContentID(),newContent);
				
				//Invoke tool's importToolContent() method.
				try{
					//begin to import
					ToolContentManager contentManager = (ToolContentManager) findToolService(newTool);
					log.debug("Tool begin to import content : " + activity.getActivityTitle() +" by contentID :" + activity.getToolContentID());

					//tool's importToolContent() method
					//get from and to version
					String toVersion = newTool.getToolVersion();
					String fromVersion = activity.getToolVersion();
					contentManager.importToolContent(newContent.getToolContentId(),importer.getUserId(),toolPath,fromVersion,toVersion);
					
					log.debug("Tool content import success.");
				}catch (Exception e) {
					String error = getMessageService().getMessage(ERROR_SERVICE_ERROR,new Object[]{newTool.getToolDisplayName(),e.toString()});
					log.error(error,e);
					toolsErrorMsgs.add(error);
					//remove any unsucessed activities from new Learning design.
					removedActMap.put(activity.getActivityID(), activity);
				}
			} //end all activities import
			
			//all activities can not imported, ignore this LD
			if(removedActMap.size() == activities.size() ){
				toolsErrorMsgs.add(getMessageService().getMessage(ERROR_NO_VALID_TOOL));
				return -1L;
			}
				
			// begin fckeditor content folder import
			try {
				String contentZipFileName = EXPORT_LDCONTENT_ZIP_PREFIX + ldDto.getContentFolderID() + EXPORT_LDCONTENT_ZIP_SUFFIX;
				String secureDir = Configuration.get(ConfigurationKeys.LAMS_EAR_DIR) + File.separator + FileUtil.LAMS_WWW_DIR 
						+ File.separator + FileUtil.LAMS_WWW_SECURE_DIR + File.separator + ldDto.getContentFolderID();
				File contentZipFile = new File(FileUtil.getFullPath(learningDesignPath, contentZipFileName));
				
				// unzip file to target secure dir if exists
				if(contentZipFile.exists()) {
					InputStream is = new FileInputStream(contentZipFile);
					ZipFileUtil.expandZipToFolder(is, secureDir);
				}
				
			} catch (Exception e) {
				throw new ImportToolContentException(e);
			}
			
			//save learning design
			WorkspaceFolder folder = getWorkspaceFolderForDesign(importer, workspaceFolderUid);
			return saveLearningDesign(ldDto,importer,folder,toolMapper,removedActMap);
			
		}catch (ToolException e) {
			throw new ImportToolContentException(e);
		} catch (FileNotFoundException e) {
			throw new ImportToolContentException(e);
		} catch (UnsupportedEncodingException e) {
			throw new ImportToolContentException(e);
		}
		
	}
	private WorkspaceFolder getWorkspaceFolderForDesign(User importer, Integer workspaceFolderUid) throws ImportToolContentException {
		// if workspaceFolderUid == null use the user's default folder
		WorkspaceFolder folder = null;
		if ( workspaceFolderUid != null ) {
			folder = (WorkspaceFolder)baseDAO.find(WorkspaceFolder.class,workspaceFolderUid);
		} 				
		if ( folder == null && importer.getWorkspace() != null) {
			folder = importer.getWorkspace().getDefaultFolder();
		}
		if ( folder == null ) {
			String error = "Unable to save design in a folder - folder not found. Input folder uid="+workspaceFolderUid+
					" user's default folder "+importer.getWorkspace();
			log.error(error);
			throw new ImportToolContentException(error);
		}
		return folder;
	}

	/**
	 * Import tool content 
	 */
	public Object importToolContent(String toolContentPath, IToolContentHandler toolContentHandler,String fromVersion,String toVersion) throws ImportToolContentException{
		Object toolPOJO = null;
//		change xml to Tool POJO 
		XStream toolXml = new XStream();
		
		Converter c = toolXml.getConverterLookup().defaultConverter();
		FileInvocationHandler handler = null;
		if(!fileHandleClassList.isEmpty()){
			//create proxy class
			handler = new FileInvocationHandler(c);
			handler.setFileHandleClassList(fileHandleClassList);
			Converter  myc = (Converter) Proxy.newProxyInstance(c.getClass().getClassLoader(),new Class[]{Converter.class},handler);
			//registry to new proxy convert to XStream
			toolXml.registerConverter(myc);				
		}
		
		List<ValueInfo> valueList = null;
		try {
			
			//tool.xml full path
			String toolFilePath = FileUtil.getFullPath(toolContentPath,TOOL_FILE_NAME);
			if(filterClass != null && !StringUtils.equals(fromVersion,toVersion)){
				filterVersion(toolFilePath,fromVersion,toVersion);
			}
			//clear and ensure next activity can get correct filter thru registerImportVersionFilterClass().
			filterClass = null;
			
			//read tool file after transform.
			Reader toolFile = new InputStreamReader(new FileInputStream(toolFilePath),"UTF-8");
			toolPOJO = toolXml.fromXML(toolFile);
			
			//upload file node if has
			if(handler != null){
				valueList = handler.getFileNodes();
				for(ValueInfo fileNode:valueList){
					
					Long uuid = NumberUtils.createLong(BeanUtils.getProperty(fileNode.instance,fileNode.name.uuidFieldName));
					//For instance, item class in share resource tool may be url or single file. If it is URL, then the 
					//file uuid will be null. Ignore it!
					if(uuid == null)
						continue;
					
					Long version = null;
					//optional
					try{
						version = NumberUtils.createLong(BeanUtils.getProperty(fileNode.instance,fileNode.name.versionFieldName));
					} catch (Exception e ) {
						log.debug("No method for version:" + fileNode.instance);
					}
					
					//according to upload rule: the file name will be uuid.
					String realFileName = uuid.toString();
					String fullFileName = FileUtil.getFullPath(toolContentPath,realFileName);
					log.debug("Tool attachement files/packages are going to upload to repository " + fullFileName);
					
					//to check if the file is package (with extension name ".zip") or single file (no extension name).
					File file = new File(fullFileName); 
					boolean isPackage = false;
					if(!file.exists()){
						file = new File(fullFileName+EXPORT_TOOLCONTNET_ZIP_SUFFIX);
						realFileName = realFileName + EXPORT_TOOLCONTNET_ZIP_SUFFIX;
						isPackage = true;
						//if this file is norpackage neither single file, throw exception.
						if(!file.exists())
							throw new ImportToolContentException("Content attached file/package can not be found: " + fullFileName + "(.zip)");
					}
					
					//more fields values for Repository upload use
					String fileName = BeanUtils.getProperty(fileNode.instance,fileNode.name.fileNameFieldName);
					String fileProperty = BeanUtils.getProperty(fileNode.instance,fileNode.name.filePropertyFieldName);
					//optional fields
					String mimeType = null;
					try {
						mimeType = BeanUtils.getProperty(fileNode.instance,fileNode.name.mimeTypeFieldName);
					} catch (Exception e ) {
						log.debug("No method for mimeType:" + fileNode.instance);
					}
					String initalItem = null;
					try {
						initalItem = BeanUtils.getProperty(fileNode.instance,fileNode.name.initalItemFieldName);
					} catch (Exception e ) {
						log.debug("No method for initial item:" + fileNode.instance);
					}
	
					InputStream is = new FileInputStream(file);
					//upload to repository: file or pacakge
					NodeKey key;
					if(!isPackage)
						key = toolContentHandler.uploadFile(is,fileName,mimeType,fileProperty);
					else{
						String packageDirectory = ZipFileUtil.expandZip(is, realFileName);
						key = toolContentHandler.uploadPackage(packageDirectory,initalItem);
					}
					
					//refresh file node Uuid and Version value to latest.
					BeanUtils.setProperty(fileNode.instance,fileNode.name.uuidFieldName,key.getUuid());
					//version id is optional
					if(fileNode.name.versionFieldName != null)
						BeanUtils.setProperty(fileNode.instance,fileNode.name.versionFieldName,key.getVersion());
				}
			}
		} catch (Exception e) {
			throw new ImportToolContentException(e);
		}finally{
			if(fileHandleClassList != null)
				fileHandleClassList.clear();
			if( valueList != null)
				valueList.clear();
		}
		
		return toolPOJO;
	}
	
	//******************************************************************
	// ApplicationContextAware method implementation
	//******************************************************************
	public void setApplicationContext(ApplicationContext context) throws BeansException {
		this.applicationContext = context;
	}
	//******************************************************************
	// Private methods
	//******************************************************************
	/**
	 * Execute XSLT to generate IMS XML file.
	 */
	private Document transform(InputStream sourceDoc, File stylesheetFile, Map<String, Object> params) throws Exception {
		// Set up the XSLT stylesheet 
		TransformerFactory transformerFactory = TransformerFactory.newInstance();
		
		log.debug("Export IMS: using XSLT file " + stylesheetFile.getAbsolutePath() + " to transforming...");
		Templates stylesheet = transformerFactory.newTemplates(new StreamSource(stylesheetFile.getAbsolutePath()));
		Transformer processor = stylesheet.newTransformer();
		
		//put initial params
		Set<Map.Entry<String, Object>> entrys = params.entrySet();
		for (Map.Entry<String, Object> entry : entrys) {
			processor.setParameter(entry.getKey(), entry.getValue());
		}
		
		//result writer
		StringWriter writer = new StringWriter();
		
		// Feed the resultant I/O stream into the XSLT processor
		StreamSource source = new StreamSource(sourceDoc);
		StreamResult result = new StreamResult(writer);
		
		//transform
		processor.transform(source, result);
		
		// Convert the resultant transformed document back to JDOM
		SAXBuilder builder = new SAXBuilder();
		Document resultDoc = builder.build(new StringReader(writer.toString()));
		
		return resultDoc;
	}

	/**
	 * Tansform tool XML file to correct version format.
	 * @param toVersion 
	 * @param fromVersion 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	private void filterVersion(String toolFilePath, String fromVersion, String toVersion) throws Exception {
		float from = 0;
		try {
			from = NumberUtils.createFloat(fromVersion);
		} catch (Exception e) {}
		float to = 0;
		try {
			to = NumberUtils.createFloat(toVersion);
		} catch (Exception e) {}
		
		String filterMethodPrefix;
		if(from > to)
			filterMethodPrefix = FILTER_METHOD_PREFIX_DOWN;
		else
			filterMethodPrefix = FILTER_METHOD_PREFIX_UP;
		
		log.debug("Version filter class will filter from version " + from + " to " + to);
		
		Object filter = filterClass.newInstance();
		Method[] methods = filterClass.getDeclaredMethods();
		Map<Float, Method> methodNeeds = new TreeMap<Float, Method>();
		for (Method method : methods) {
			String name = method.getName();
			if(name.startsWith(filterMethodPrefix)){
				String[] ver = name.split(filterMethodPrefix+"|"+FILTER_METHOD_MIDDLE);
				Float mf = 0f;
				Float mt = 0f;
				for (int idx=0;idx<ver.length;idx++){
					if(StringUtils.isBlank(ver[idx]))
						continue;
					mf = NumberUtils.createFloat(ver[idx]);
					if(ver.length > idx)
					mt = NumberUtils.createFloat(ver[++idx]);
					break;
				}
				if(mf >= from && mt <= to){
					methodNeeds.put(mf,method);
				}
			}
		}
		Collection<Method> calls = methodNeeds.values();
		for (Method method : calls) {
			method.invoke(filter, new Object[]{});
			log.debug("Version filter class method " + method.getName() +" is executed.");
		}
		Method transform = filterClass.getMethod("transformXML",new Class[]{String.class});
		transform.invoke(filter, new Object[]{toolFilePath});
	
		
	}
	/**
	 * If there are any errors happen during tool exporting content. Writing failed message to file.
	 */
	private void writeErrorToToolFile(String rootPath,Long toolContentId, String msg) {
		//create tool's save path
		try {
			String toolPath = FileUtil.getFullPath(rootPath,toolContentId.toString());
			FileUtil.createDirectory(toolPath);
		
			//create tool xml file name : tool.xml
			String toolFileName = FileUtil.getFullPath(toolPath,TOOL_FAILED_FILE_NAME);
			Writer toolFile = new FileWriter(new File(toolFileName));
			toolFile.write(msg);
			toolFile.flush();
			toolFile.close();
		} catch (FileUtilException e) {
			log.warn("Export error file write error:" + e.toString());
		} catch (IOException e) {
			log.warn("Export error file write error:" + e.toString());
		}
	}	
	private ILearningDesignService getLearningDesignService(){
		return (ILearningDesignService) applicationContext.getBean(LEARNING_DESIGN_SERVICE_BEAN_NAME);		
	}
	private MessageService getMessageService(){
		if(messageService != null)
			return messageService;
		
		return (messageService = (MessageService) applicationContext.getBean(MESSAGE_SERVICE_BEAN_NAME));		
	}
	private LD102Importer getLD102Importer(){
		return (LD102Importer) applicationContext.getBean(LD102IMPORTER_BEAN_NAME);		
	}
	
	
	private Object findToolService(Tool tool) throws NoSuchBeanDefinitionException
    {
        return applicationContext.getBean(tool.getServiceName());
    }
	
	public Long saveLearningDesign(LearningDesignDTO dto, User importer, WorkspaceFolder folder, 
				Map<Long,ToolContent> toolMapper, Map<Long,AuthoringActivityDTO> removedActMap)
			throws ImportToolContentException {

		//grouping object list
		List<GroupingDTO> groupingDtoList = dto.getGroupings();
		Map<Long,Grouping> groupingMapper = new HashMap<Long,Grouping>();
		for(GroupingDTO groupingDto : groupingDtoList){
			Grouping grouping = getGrouping(groupingDto);
			groupingMapper.put(grouping.getGroupingId(),grouping);
			
			//persist
			grouping.setGroupingId(null);
			groupingDAO.insert(grouping);
		}
		
		//================== Start handle activities ======================
		//activity object list
		//sort them to ensure parent before its children.
		List<AuthoringActivityDTO> actDtoList = getSortedParentList(dto.getActivities());
		
		if(log.isDebugEnabled()){
			int idx=0;
			for (AuthoringActivityDTO activityDTO : actDtoList) {
				log.debug(idx + ": ActivityID is [" + activityDTO.getActivityID() + "], parent ID is [" + activityDTO.getParentActivityID() + "]");
				idx++;
			}
		}
		Set<Activity> actList = new TreeSet<Activity> (new ActivityOrderComparator());
		Map<Long,Activity> activityMapper = new HashMap<Long,Activity>();
		
		for(AuthoringActivityDTO actDto: actDtoList){
			Activity act = getActivity(actDto,groupingMapper,toolMapper);
			//so far, the activitiy ID is still old one, so setup the mapping relation between old ID and new activity.
			activityMapper.put(act.getActivityId(),act);
			//if this act is removed, then does not save it into LD
			if(!removedActMap.containsKey(actDto.getActivityID()))
				actList.add(act);
		}
		//rescan the activity list and refresh their parent activity.
		for(AuthoringActivityDTO actDto: actDtoList){
			Activity act = activityMapper.get(actDto.getActivityID());
			if(removedActMap.containsKey(actDto.getActivityID()))
				continue;
			
			if(actDto.getParentActivityID() != null){
				Activity parent = activityMapper.get(actDto.getParentActivityID());
				//reset children's parent as null if parent already removed
				if(removedActMap.containsKey(parent.getActivityId())){
					act.setParentActivity(null);
					act.setParentUIID(null);
				}else{
					act.setParentActivity(parent);
					//also add child as Complex activity: It is useless for persist data, but helpful for validate in learning design!
					if(isComplexActivity(parent)){
						Set<Activity> set = ((ComplexActivity)parent).getActivities();
						if(set == null){
							set = new TreeSet<Activity>(new ActivityOrderComparator());
							((ComplexActivity)parent).setActivities(set);
						}
						if(!removedActMap.containsKey(actDto.getActivityID()))
							set.add(act);
					}
				}
			}
			
			//persist
			act.setActivityId(null);
			activityDAO.insert(act);
		}
		
		
//		reset first activity UUID for LD if old first removed
		//set first as remove activity's next existed one
		Integer actUiid = dto.getFirstActivityUIID();
		if(actUiid != null){
			for(AuthoringActivityDTO actDto: actDtoList){
				if(actUiid.equals(actDto.getActivityUIID())){
					//if first activity is removed
					if(removedActMap.containsKey(actDto.getActivityID())){
						List<TransitionDTO> transDtoList = dto.getTransitions();
						Long existFirstAct = null;
						Long nextActId = actDto.getActivityID();
						boolean found = false;
						// try to find next availble activity
						//1000 is failure tolerance: to avoid dead loop.
						for(int idx=0;idx<1000;idx++){
							if(transDtoList == null || transDtoList.isEmpty())
								break;
							boolean tranisionBreak = true;
							for(TransitionDTO transDto: transDtoList){
								//find out the transition of current first activity
								if(nextActId.equals(transDto.getFromActivityID())){
									tranisionBreak = false;
									nextActId = transDto.getToActivityID();
									if(nextActId != null && !removedActMap.containsKey(nextActId)){
										existFirstAct = nextActId;
										found = true;
										break;
									}else if(nextActId == null){
										//no more activity
										found = true;
										break;
									}
									//already found the desire transition
									break;
									//if found flag is false yet, then it means the 2nd node remove as well, 
									//continue try 3rd...
								}
							}
							//hi, this acitivty also removed!!! then retrieve again
							//if found is false, then the nextAct is still not available, then continue find.
							//tranisionBreak mean the activity is removed but it can not find its transition to decide next available activity.
							if(found || tranisionBreak)
								break;
						}
						Activity next = activityMapper.get(existFirstAct);
						dto.setFirstActivityUIID(next == null?null:next.getActivityUIID());
					}
					//find out the first activity, then break;
					break;
				}
			}
		}
		//================== END handle activities ======================
		
		//transition object list
		List<TransitionDTO> transDtoList = dto.getTransitions();
		Set<Transition> transList = new HashSet<Transition>();
		for(TransitionDTO transDto: transDtoList){
			//Any transitions relating with this tool will be removed!
			Long fromId = transDto.getFromActivityID();
			Long toId = transDto.getToActivityID();
			if(fromId != null && removedActMap.containsKey(fromId)){
				continue;
			}
			if(toId != null && removedActMap.containsKey(toId)){
				continue;
			}
			Transition trans = getTransition(transDto,activityMapper);
			transList.add(trans);
			
			//persist
			trans.setTransitionId(null);
			//leave it to learning design to save it.
//			transitionDAO.insert(trans);
		}
		
		
		LearningDesign ld = getLearningDesign(dto,importer,folder,actList,transList,activityMapper);
		
//		validate learning design
		Vector listOfValidationErrorDTOs = (Vector)getLearningDesignService().validateLearningDesign(ld);
		if(listOfValidationErrorDTOs.size() > 0 ){
			ld.setValidDesign(false);
			log.error(listOfValidationErrorDTOs);
//			throw new ImportToolContentException("Learning design validate error.");
		}else
			ld.setValidDesign(true);
		
		ld.setTitle(ImportExportUtil.generateUniqueLDTitle(folder, ld.getTitle(), learningDesignDAO));
		
//		persist
		learningDesignDAO.insert(ld);
		
		return ld.getLearningDesignId();
	}
	
	 
	 /**
	  * Method to sort activity DTO according to the rule: Paretns is before their children. 
	  * @param activities
	  * @return
	  */
	private List<AuthoringActivityDTO> getSortedParentList(List<AuthoringActivityDTO> activities) {
		List<AuthoringActivityDTO> result = new ArrayList<AuthoringActivityDTO>();
		List<Long> actIdList = new ArrayList<Long>();
		
		//NOTICE: this code can not handle all nodes have their parents, ie, there is at least one node parent is null(root). 
		int failureToleranceCount = 5000;
		while(!activities.isEmpty() && failureToleranceCount > 0){
			Iterator<AuthoringActivityDTO> iter = activities.iterator();
			while (iter.hasNext()) {
				AuthoringActivityDTO actDto = iter.next();
				if(actDto.getParentActivityID() == null){
					result.add(actDto);
					actIdList.add(actDto.getActivityID());
					iter.remove();
				}else if(actIdList.contains(actDto.getParentActivityID())){
					result.add(actDto);
					actIdList.add(actDto.getActivityID());
					iter.remove();
				}
			}
			failureToleranceCount--;
		}
		if(!activities.isEmpty()){
			log.warn("Some activities cannot found their parent actitivy.");
			//just append these activies into result list 
			for (AuthoringActivityDTO actDto : activities) {
				log.warn("Activity ID[" + actDto.getActivityID() + "] cannot found parent [" + actDto.getParentActivityID() + "]");
			}
			result.addAll(activities);
		}
		return result;
	}
	/**
	 * Get learning design object from this Learning design DTO object. It also following our
	 * import rules:
	 * <li>lams_license - Assume same in all lams system. Import same ID</li>
	 * <li>lams_copy_type - Set to 1.This indicates it is "normal" design.</li>
	 * <li>lams_workspace_folder - An input parameters to let user choose import workspace</li>
	 * <li>User - The person who execute import action</li>
	 * <li>OriginalLearningDesign - set to null</li>
	 * @param activityMapper 
	 * 
	 * @return
	 * @throws ImportToolContentException 
	 */
	private LearningDesign getLearningDesign(LearningDesignDTO dto, User importer, WorkspaceFolder folder,
			Set<Activity> actList, Set<Transition> transList, Map<Long, Activity> activityMapper) throws ImportToolContentException {
		LearningDesign ld = new LearningDesign();
	
		if(dto == null)
			return ld;
		
		ld.setLearningDesignId(dto.getLearningDesignID());
		ld.setLearningDesignUIID(dto.getLearningDesignUIID());
		ld.setDescription(dto.getDescription());
		ld.setTitle(dto.getTitle());
		
		Integer actUiid = dto.getFirstActivityUIID();
		if(actUiid != null){
			for(Activity act : activityMapper.values()){
				if(actUiid.equals(act.getActivityUIID())){
					ld.setFirstActivity(act);
					break;
				}
			}
		}
		
		ld.setMaxID(dto.getMaxID());
		ld.setValidDesign(dto.getValidDesign());
		ld.setReadOnly(dto.getReadOnly());
		ld.setDateReadOnly(dto.getDateReadOnly());
		ld.setOfflineInstructions(dto.getOfflineInstructions());	
		ld.setOnlineInstructions(dto.getOnlineInstructions());
		
		ld.setHelpText(dto.getHelpText());
		//set to 1
		ld.setCopyTypeID(1);
		ld.setCreateDateTime(dto.getCreateDateTime());
		ld.setVersion(dto.getVersion());
		
		if(folder != null)
			ld.setWorkspaceFolder(folder);
								 
		ld.setDuration(dto.getDuration());
		ld.setLicenseText(dto.getLicenseText());
		
		Long licenseId = dto.getLicenseID();
		if(licenseId != null){
			License license = licenseDAO.getLicenseByID(licenseId);
			if(license == null)
				throw new ImportToolContentException("Import failed: License ["+dto.getLicenseText()+ "] does not exist in target database");
			ld.setLicense(licenseDAO.getLicenseByID(licenseId));
			ld.setLicenseText(dto.getLicenseText());
		}
		
		ld.setLastModifiedDateTime(dto.getLastModifiedDateTime());
		ld.setContentFolderID(dto.getContentFolderID());
		
		//set learning design to transition.
		for(Transition trans:transList){
			trans.setLearningDesign(ld);
		}
		ld.setTransitions(transList);

		for(Activity act :actList)
			act.setLearningDesign(ld);
		ld.setActivities(actList);
		
		ld.setCreateDateTime(new Date());
		ld.setLastModifiedDateTime(new Date());
		ld.setUser(importer);
		return ld;
	}
	/**
	 * Return Grouping object from given GroupingDTO.
	 * 
	 * @param groupingDto
	 * @return
	 */
	private Grouping getGrouping(GroupingDTO groupingDto) {
		Grouping grouping = null;
		if(groupingDto == null)
			return grouping;
		
		Integer type = groupingDto.getGroupingTypeID();
		
//		grouping.setActivities();
		if (Grouping.CHOSEN_GROUPING_TYPE.equals(type)) {
			grouping = new ChosenGrouping();
		}else if (Grouping.RANDOM_GROUPING_TYPE.equals(type)) {
			grouping = new RandomGrouping();
			((RandomGrouping)grouping).setLearnersPerGroup(groupingDto.getLearnersPerGroup());
			((RandomGrouping)grouping).setNumberOfGroups(groupingDto.getNumberOfGroups());
		}else if (Grouping.CLASS_GROUPING_TYPE.equals(type)) {
			grouping = new LessonClass();
		}
		
		//commont fields
		grouping.setGroupingId(groupingDto.getGroupingID());
		grouping.setGroupingUIID(groupingDto.getGroupingUIID());
		grouping.setMaxNumberOfGroups(groupingDto.getMaxNumberOfGroups());
		
		return grouping;
	}
	
	private Transition getTransition(TransitionDTO transDto, Map<Long, Activity> activityMapper) {
		Transition trans = new Transition();
		
		if(transDto == null)
			return trans;
		
		trans.setDescription(transDto.getDescription());
		Activity fromAct = activityMapper.get(transDto.getFromActivityID());
		trans.setFromActivity(fromAct);
		trans.setFromUIID(fromAct.getActivityUIID());
		//also set transition to activity: It is nonsense for persisit data, but it is help this learning design validated
		fromAct.setTransitionTo(trans);
//		set to null 
//		trans.setLearningDesign();
		trans.setTitle(transDto.getTitle());
		
		Activity toAct = activityMapper.get(transDto.getToActivityID());
		trans.setToActivity(toAct);
		trans.setToUIID(toAct.getActivityUIID());
		//also set transition to activity: It is nonsense for persisit data, but it is help this learning design validated
		toAct.setTransitionFrom(trans);
		
		trans.setTransitionId(transDto.getTransitionID());
		trans.setTransitionUIID(transDto.getTransitionUIID());
		
		//reste value
		trans.setCreateDateTime(new Date());
		return trans;
	}
	/**
	 * 
	 * @param actDto
	 * @param activityMapper 
	 * @param groupingList
	 * @param toolMapper
	 * @return
	 */
	private Activity getActivity(AuthoringActivityDTO actDto, Map<Long, Grouping> groupingList, Map<Long,ToolContent> toolMapper) {
		Activity act = null;
		if(actDto == null)
			return act;
		int type = actDto.getActivityTypeID().intValue();
		Grouping newGrouping;
		switch(type){
			case Activity.TOOL_ACTIVITY_TYPE:
				act = new ToolActivity();
				//get back the toolContent in new system by toolContentID in old system.
				ToolContent content = toolMapper.get(actDto.getToolContentID());
				//if activity can not find matching tool, the content should be null.
				if(content != null){
					((ToolActivity)act).setTool(content.getTool());
					((ToolActivity)act).setToolContentId(content.getToolContentId());
					((ToolActivity)act).setToolSessions(null);
				}
				break;
			case Activity.GROUPING_ACTIVITY_TYPE:
				act = new GroupingActivity();
				newGrouping = groupingList.get(actDto.getCreateGroupingID());
				((GroupingActivity)act).setCreateGrouping(newGrouping);
				((GroupingActivity)act).setCreateGroupingUIID(newGrouping.getGroupingUIID());
				break;
			case Activity.SYNCH_GATE_ACTIVITY_TYPE:
				act = new SynchGateActivity();
				((SynchGateActivity)act).setGateActivityLevelId(actDto.getGateActivityLevelID());
				//always set false
				((SynchGateActivity)act).setGateOpen(false);
				((SynchGateActivity)act).setWaitingLearners(null);
				((SynchGateActivity)act).setSystemTool(systemToolDAO.getSystemToolByID(SystemTool.SYNC_GATE));
				break;
			case Activity.SCHEDULE_GATE_ACTIVITY_TYPE:
				act = new ScheduleGateActivity();
				((ScheduleGateActivity)act).setGateActivityLevelId(actDto.getGateActivityLevelID());
				((ScheduleGateActivity)act).setWaitingLearners(null);
				//always set false
				((ScheduleGateActivity)act).setGateOpen(false);
				
				((ScheduleGateActivity)act).setGateEndDateTime(actDto.getGateEndDateTime());
				((ScheduleGateActivity)act).setGateStartDateTime(actDto.getGateStartDateTime());
				((ScheduleGateActivity)act).setGateStartTimeOffset(actDto.getGateStartTimeOffset());
				((ScheduleGateActivity)act).setGateEndTimeOffset(actDto.getGateEndTimeOffset());
				((ScheduleGateActivity)act).setSystemTool(systemToolDAO.getSystemToolByID(SystemTool.SCHEDULE_GATE));
				break;
			case Activity.PERMISSION_GATE_ACTIVITY_TYPE:
				act = new PermissionGateActivity();
				((PermissionGateActivity)act).setGateActivityLevelId(actDto.getGateActivityLevelID());
				((PermissionGateActivity)act).setGateOpen(false);
				((PermissionGateActivity)act).setWaitingLearners(null);
				((PermissionGateActivity)act).setSystemTool(systemToolDAO.getSystemToolByID(SystemTool.PERMISSION_GATE));
				break;
			case Activity.PARALLEL_ACTIVITY_TYPE:
				act = new ParallelActivity();
				break;
			case Activity.OPTIONS_ACTIVITY_TYPE:
				act = new OptionsActivity();
				((OptionsActivity)act).setMaxNumberOfOptions(actDto.getMaxOptions());
				((OptionsActivity)act).setMinNumberOfOptions(actDto.getMinOptions());
				((OptionsActivity)act).setOptionsInstructions(actDto.getOptionsInstructions());
				break;
			case Activity.SEQUENCE_ACTIVITY_TYPE:
				act = new SequenceActivity();
				break;
		}		
		
		act.setGroupingSupportType(actDto.getGroupingSupportType());
		act.setActivityUIID(actDto.getActivityUIID());
		act.setActivityCategoryID(actDto.getActivityCategoryID());
		act.setActivityId(actDto.getActivityID());
		act.setActivityTypeId(actDto.getActivityTypeID());
		act.setApplyGrouping(actDto.getApplyGrouping());
		act.setDefineLater(actDto.getDefineLater());
		act.setDescription(actDto.getDescription());
		act.setHelpText(actDto.getHelpText());
		act.setLanguageFile(actDto.getLanguageFile());
		//do not need set so far
//		act.setLearningDesign();
		
//		the id will be decide in LearningObject 
//		actDto.getLearningDesignID()
//		act.setLearningLibrary();
		
		//be to decided by Fiona: 08/06/2006: It is ok to left it as null
//		actDto.getLibraryActivityID()
//		act.setLibraryActivity();
		
		act.setLibraryActivityUiImage(actDto.getLibraryActivityUIImage());
		act.setOrderId(actDto.getOrderID());

		//temporarily set as to null, after scan all activities, then set it to valid value.
		act.setParentActivity(null);
		
		act.setParentUIID(actDto.getParentUIID());
		act.setRunOffline(actDto.getRunOffline());
		act.setTitle(actDto.getActivityTitle());
		
		//relation will be decide in Transition object.
//		act.setTransitionFrom();
//		act.setTransitionTo();
		
		act.setXcoord(actDto.getxCoord());
		act.setYcoord(actDto.getyCoord());
		
		//tranfer old grouping to latest
		newGrouping = groupingList.get(actDto.getGroupingID());
		act.setGrouping(newGrouping);
		if(newGrouping != null)
			act.setGroupingUIID(newGrouping.getGroupingUIID());

		act.setCreateDateTime(new Date());
		return act;
	}
	//******************************************************************
	// Spring injection properties set/get
	//******************************************************************
	public IActivityDAO getActivityDAO() {
		return activityDAO;
	}
	public void setActivityDAO(IActivityDAO activityDAO) {
		this.activityDAO = activityDAO;
	}
	public IGroupingDAO getGroupingDAO() {
		return groupingDAO;
	}
	public void setGroupingDAO(IGroupingDAO groupingDAO) {
		this.groupingDAO = groupingDAO;
	}
	public ILearningDesignDAO getLearningDesignDAO() {
		return learningDesignDAO;
	}
	public void setLearningDesignDAO(ILearningDesignDAO learningDesignDAO) {
		this.learningDesignDAO = learningDesignDAO;
	}
	public ILicenseDAO getLicenseDAO() {
		return licenseDAO;
	}
	public void setBaseDAO(IBaseDAO baseDAO) {
		this.baseDAO = baseDAO;
	}
	public void setLicenseDAO(ILicenseDAO licenseDAO) {
		this.licenseDAO = licenseDAO;
	}
	public IToolContentDAO getToolContentDAO() {
		return toolContentDAO;
	}
	public void setToolContentDAO(IToolContentDAO toolContentDAO) {
		this.toolContentDAO = toolContentDAO;
	}
	public IToolDAO getToolDAO() {
		return toolDAO;
	}
	public void setToolDAO(IToolDAO toolDAO) {
		this.toolDAO = toolDAO;
	}
	public ITransitionDAO getTransitionDAO() {
		return transitionDAO;
	}
	public void setTransitionDAO(ITransitionDAO transitionDAO) {
		this.transitionDAO = transitionDAO;
	}
	private boolean isComplexActivity(Activity act)
	{
		return act.getActivityTypeId().intValue() == Activity.SEQUENCE_ACTIVITY_TYPE || 
		 act.getActivityTypeId().intValue()== Activity.PARALLEL_ACTIVITY_TYPE ||
		 act.getActivityTypeId().intValue()== Activity.OPTIONS_ACTIVITY_TYPE;
	}
	public void setToolImportSupportDAO(IToolImportSupportDAO toolImportSupportDAO) {
		this.toolImportSupportDAO = toolImportSupportDAO;
	}
	public void setLearningLibraryDAO(ILearningLibraryDAO learningLibraryDAO) {
		this.learningLibraryDAO = learningLibraryDAO;
	}
	public void setSystemToolDAO(ISystemToolDAO systemToolDAO) {
		this.systemToolDAO = systemToolDAO;
	}
}