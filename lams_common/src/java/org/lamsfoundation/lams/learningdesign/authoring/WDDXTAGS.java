/*
 * Created on Jan 11, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.lamsfoundation.lams.learningdesign.authoring;

import java.util.Date;



/**
 * @author Minhas
 * The tags used in WDDX Packet
 */
public interface WDDXTAGS {
	
	/* General Tags */
	public static final String OBJECT_TYPE = "objectType";
	public static final String DESCRIPTION = "description";
	public static final String TITLE = "title";
	public static final String ID ="id";
	public static final String XCOORD="xcoord";
	public static final String YCOORD="ycoord";
	public static final String READ_ACCESS="read_access";
	public static final String WRITE_ACCESS="write_access";
	
	/*Learning Library specific tags */
	public static final String LEARNING_LIBRARY_ID ="learning_library_id";
	public static final String LEARNING_DESIGN_ID="learning_design_id";
	public static final String TRANSITION_ID ="transition_id";
	public static final String TOOL_ID="tool_id";
	public static final String TOOL_CONTENT_ID="tool_content_id";
	
	public static final String CREATION_DATE ="create_date_time";
	
	public static final String LIB_ACTIVITIES="activities";
	public static final String LIB_PACKAGE = "libraries";
	public static final String DESIGN_PACKAGE ="designs";
	
	
	public static final Long NUMERIC_NULL_VALUE_LONG = new Long(-1);
	public static final Integer NUMERIC_NULL_VALUE_INTEGER = new Integer(-1);
	public static final Date DATE_NULL_VALUE = new Date();
	public static final Boolean BOOLEAN_NULL_VALUE = new Boolean("false");
	
	/*Activity specific tags*/
	public static final String ACTIVITY_ID ="activity_id";
	public static final String PARENT_ACTIVITY_ID ="parent_activity_id";
	public static final String ACTIVITY_TYPE_ID ="learning_activity_type_id";
	public static final String GROUPING_ID ="grouping_id";
	public static final String ORDER_ID ="order_id";
	public static final String DEFINE_LATER ="define_later_flag";
	public static final String OFFLINE_INSTRUCTIONS ="offline_instructions";
	public static final String MAX_OPTIONS="max_number_of_options";
	public static final String MIN_OPTIONS="min_number_of_options";
	public static final String LIBRARY_IMAGE ="library_activity_ui_image";
	
	public static final String GATE_ACTIVITY_LEVEL_ID ="gate_activity_level_id";
	public static final String GATE_START_DATE ="gate_start_date_time";
	public static final String GATE_END_DATE ="gate_end_date_time";
	
	public static final String PROGRESS_CURRENT="progressCurrent";
	public static final String PROGRESS_COMPLETED="progressCompleted";
	
	public static final String LEARNER_PROGRESS_ID="learner_progress_id";
	
	/*Transition specific tags */
	public static final String ACTIVITY_TYPE ="activityType";
	public static final String ACTIVITY_TRANSITIONS ="activityTransitions";
	public static final String TRANSITION_TO="toActivity";
	public static final String TRANSITION_FROM="fromActivity";
	
	/*Learning Design specific tags*/
	public static final String FIRST_ACTIVITY_ID ="first_activity_id";
	public static final String MAX_ID ="max_id";
	public static final String VALID_DESIGN ="valid_design_flag";
	public static final String READ_ONLY ="read_only_flag";
	public static final String DATE_READ_ONLY ="date_read_only";
	public static final String HELP_TEXT ="help_text";
	public static final String LESSON_COPY="lesson_copy_flag";
	public static final String VERSION="version";
	public static final String PARENT_DESIGN_ID ="parent_learning_design_id";
	public static final String OPEN_DATE="open_date_time";
	public static final String CLOSE_DATE="close_date_time";
	public static final String USER_ID="user_id";
}
