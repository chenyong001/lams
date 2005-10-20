﻿import org.lamsfoundation.lams.authoring.*;
import org.lamsfoundation.lams.common.util.*;
import org.lamsfoundation.lams.common.*;
/*
*
* DesignDataModel stores all the data relating to the design
* 
* Note the hashtable of _activities might contain the following types:
* 		1) ToolActivities
* 		2) Grouping activities which reference a _groupings element
* 		3) Parallel activities which reference 2 or more other _activitiy elements
* 		4) Optional activities which reference 2 or more other _activitiy elements
* 		5) Gate activities
* 
* 
* @author      DC
* @version     0.1
*    
*/

class org.lamsfoundation.lams.authoring.DesignDataModel {
	
	public static var COPY_TYPE_ID_AUTHORING:Number = 1;
	public static var COPY_TYPE_ID_RUN:Number = 2;
	public static var COPY_TYPE_ID_PREVIEW:Number = 3;	
	//LearningDesign Properties:
	
	private var _objectType:String;
	private var _copyTypeID:Number;
	

	private var _learningDesignID:Number;
	private var _title:String;
	private var _description:String;
	private var _helpText:String;
	private var _version:String;
	private var _userID:Number;
	private var _duration:Number;
	private var _readOnly:Boolean;
	private var _validDesign:Boolean;
	private var _maxID:Number;
	private var _firstActivityID:Number;
	private var _firstActivityUIID:Number;
	private var _parentLearningDesignID:Number;
	
	private var _activities:Hashtable;
	private var _transitions:Hashtable;
	private var _groupings:Hashtable;
	
	
	private var _licenseID:Number;
	private var _licenseText:String;
	private var _workspaceFolderID:Number;
	private var _createDateTime:Date;
	private var _lastModifiedDateTime:Date;
	private var _dateReadOnly:Date;
	
	
    //Constructor
    function DesignDataModel(){
        //initialise the hashtables
		_activities = new Hashtable("_activities");
		_transitions = new Hashtable("_transitions");
		
		//set the defualts:
		_objectType = "LearningDesign";
		_copyTypeID = COPY_TYPE_ID_AUTHORING;
		_version = "1.1_beta";
		_readOnly = false;
		_validDesign = false;
		
		_userID = Config.getInstance().userID;
		
    }
	
	/**
	 * Validates the design data model
	 * @usage   
	 * @return  
	 */
	public function validate():Boolean{
		var success:Boolean= false;
		Debugger.log("******* FUNCTION NOT IMPLEMENTED",Debugger.CRITICAL,'validate','DesignDataModel');
		return success;
	}
	
	//Helper methods.
	
	/**
	* Adds a template activity to the model. 
	* 
	*/
	public function addActivity(activity:Activity):Boolean{
		var success = false;
		//create an Activity from the template actvity.
		Debugger.log('activity:'+activity.title,4,'addActivity','DesignDataModel');
		
		
		//validate the activity ??
		
		//validate if we can do it?
		
		//generate a new ID
		
		//add to DDM
		
		//ObjectUtils.printObject(activity);
		_activities.put(activity.activityUIID, activity);
		
		
		//TODO: Better validation of the addition
		success = true;
		
		
		return success;
	}
	
	public function removeActivity(activityUIID):Object{
		var r:Object = _activities.remove(activityUIID);
		if(r==null){
			return new LFError("Removing activity failed:"+activityUIID,"removeActivity",this,null);
		}else{
			Debugger.log('Removed:'+r.activityUIID,Debugger.GEN,'removeActivity','DesignDataModel');
		}
	}
	
	public function addTransition(transition:Transition):Boolean{
		
		Debugger.log('Transition from:'+transition.fromUIID+', to:'+transition.toUIID,4,'addActivity','DesignDataModel');
		_transitions.put(transition.transitionUIID,transition);
		
		//TODO some validation would be nice
		return true;
	}
	
	
	/**
	 * Sets a new design for the DDM.
	 * @usage   <DDM Instance>.setDesign(design:Object)
	 * @param   design 
	 * @return  success
	 */
	public function setDesign(design:Object):Boolean{
		var success:Boolean = false;
		//TODO:Validate if design is saved if not notify user
		success = true;
		//_global.breakpoint();
		Debugger.log('Printing the design revieced:...',Debugger.GEN,'setDesign','DesignDataModel');
		ObjectUtils.printObject(design);
		_objectType = design.objectType;
		_learningDesignID = design.learning_design_id;
		_title = design.title;
		_description = design.description;
		_helpText = design.help_text;
		_version = design.version;
	
		_userID = design.user_id;
		_workspaceFolderID = design.workspace_folder_id;
		_createDateTime = design.create_date_time;
		_readOnly = design.read_only_flag;
		_validDesign = design.valid_design_flag;
		
		_maxID = design.max_id;
		_firstActivityID = design.first_id;
		
		//set the activities in the hash table
		for(var i=0; i<design.activities.length;i++){
			//note if the design is being opened - then it must have ui_ids already
			Debugger.log('Adding activity ID:'+design.activities[i].activityUIID,Debugger.GEN,'setDesign','DesignDataModel');
			//TODO: we should be calling the constructor of these objects!
			var dto = design.activities[i];
			
			//depending on the objectType call the relevent constructor.
			if(dto.objectType = "ToolActivity"){
				var newToolActivity:ToolActivity = new ToolActivity(dto.activityUIID);
				newToolActivity.populateFromDTO(dto);				
				_activities.put(newToolActivity.activityUIID,newToolActivity);
			
			}else if(dto.objectType = "ComplexActivity"){
				
			
			}
		}
		
		//set the activities in the hash table
		for(var i=0; i<design.transitions.length;i++){
			//note if the design is being opened - then it must have ui_ids already
			Debugger.log('Adding transition ID:'+design.transitions[i].transitionUIID,Debugger.GEN,'setDesign','DesignDataModel');
			//TODO: we should be calling the constructor of these objects!
			_transitions.put(design.transitions[i].transitionUIID,design.transitions[i]);
		}
				
		return success;
	}
	
	private function prepareDesignForSaving():Void{
		
		//set create date time to now
		_createDateTime = new Date();
		//validate and set field
		_validDesign = validate();
		if(_validDesign){
			//set first ID
			
		}
		
		
		
	}
	
	public function getDesignForSaving():Object{
		prepareDesignForSaving();
		return toData();
	}
	
	public function toData():Object{
		var design:Object = new Object();
		
		//if null, use default
		
		//TODO: get this sorted - query string
		Debugger.log('1 UserID:'+_userID,Debugger.GEN,'toData','DesignDataModel');
		
		
		if(_copyTypeID == undefined){
			_copyTypeID = COPY_TYPE_ID_AUTHORING;
		}
		
		design.objectType = (_objectType) ? _objectType : Config.STRING_NULL_VALUE;
		design.copyTypeID = (_copyTypeID) ? _copyTypeID : Config.NUMERIC_NULL_VALUE;
		design.learningDesignID = (_learningDesignID) ? _learningDesignID : Config.NUMERIC_NULL_VALUE;
		design.title = _title ? _title : Config.STRING_NULL_VALUE;
		design.description = (_description) ? _description : Config.STRING_NULL_VALUE;
		design.helpText = (_helpText) ? _helpText : Config.STRING_NULL_VALUE;
		design.version = (_version) ? _version : Config.STRING_NULL_VALUE;
		design.userID = (_userID) ? _userID : Config.NUMERIC_NULL_VALUE;
		design.duration = (_duration) ? _duration: Config.NUMERIC_NULL_VALUE;
		design.readOnly = (_readOnly!=null) ? _readOnly : Config.BOOLEAN_NULL_VALUE;
		design.validDesign = (_validDesign!=null) ? _validDesign : Config.BOOLEAN_NULL_VALUE;
		design.maxID = (_maxID) ? _maxID : Config.NUMERIC_NULL_VALUE;
		design.firstActivityID = (_firstActivityID) ? _firstActivityID : Config.NUMERIC_NULL_VALUE;
		design.firstActivityUIID = (_firstActivityUIID) ? _firstActivityUIID : Config.NUMERIC_NULL_VALUE;
		design.parentLearningDesignID= (_parentLearningDesignID) ? _parentLearningDesignID: Config.NUMERIC_NULL_VALUE;
		design.licenseID= (_licenseID) ? _licenseID: Config.NUMERIC_NULL_VALUE;
		design.licenseText= (_licenseText) ? _licenseText: Config.STRING_NULL_VALUE;
		design.workspaceFolderID = (_workspaceFolderID) ? _workspaceFolderID : Config.NUMERIC_NULL_VALUE;
		design.createDateTime = (_createDateTime) ? _createDateTime : Config.DATE_NULL_VALUE;
		design.lastModifiedDateTime= (_lastModifiedDateTime) ? _lastModifiedDateTime: Config.DATE_NULL_VALUE;
		design.dateReadOnly = (_dateReadOnly) ? _dateReadOnly: Config.DATE_NULL_VALUE;
		
		
		var classActs:Array = _activities.values();
		if(classActs.length > 0){
			design.activities = new Array();
			for(var i=0; i<classActs.length; i++){
				design.activities[i] = classActs[i].toData();
			}
		}
		
		var classTrans:Array = _transitions.values();
		if(classTrans.length > 0){
			design.transitions = new Array();
			for(var i=0; i<classTrans.length; i++){
				design.transitions[i] = classTrans[i].toData();
			}
		}
		
		var classGroups:Array = _groupings.values();
		if(classGroups.length > 0){
			design.groupings = new Array();
			for(var i=0; i<classGroups.length; i++){
				//TODO: Add a toData to the gorup class (after we make the group class :)
				design[i] = classGroups[i].toData();
			}
		}

		
		return design;
	}
	
	/**
	 * Creates a new UI ID which is unique for this design.
	 * @usage   
	 * @return  newID
	 */
	public function newUIID():Number{
		//if this is the first time then initialise to 1
		if(_maxID == null){
			_maxID = 0;
		}
		//add one for a new ID
		_maxID++;
		return _maxID;
	}
	
	
	//helper methods
	public function getActivityByUIID(UIID:Number):Activity{
		
		var a:Activity = _activities.get(UIID);
		Debugger.log('Returning activity:'+a.activityUIID,Debugger.GEN,'getActivityByUIID','DesignDataModel');
		return a;
	}
	
	
	//Getters and setters for the properties
	public function get objectType():String{
		return _objectType;
	}
	
	public function set objectType(a:String):Void{
		_objectType = a;
	}
	
	public function get learningDesignID():Number{
		return _learningDesignID;
	}
	
	public function set learningDesignID(a:Number):Void{
		_learningDesignID = a;
	}
	
	public function get title():String{
		return _title;
	}
	
	public function set title(a:String):Void{
		_title = a;
	}
	
	public function get description():String{
		return _description;
	}
	
	public function set description(a:String):Void{
		_description = a;
	}
	
	public function get helpText():String{
		return _helpText;
	}
	
	public function set helpText(a:String):Void{
		_helpText = a;
	}	public function get version():String{
		return _version;
	}
	
	public function set version(a:String):Void{
		_version = a;
	}
	
	public function get userID():Number{
		return _userID;
	}
	
	public function set userID(a:Number):Void{
		_userID = a;
	}
	
	public function get workspaceFolderID():Number{
		return _workspaceFolderID;
	}
	
	public function set workspaceFolderID(a:Number):Void{
		_workspaceFolderID = a;
	}
	
	public function get createDateTime():Date{
		return _createDateTime;
	}
	
	public function set createDateTime(a:Date):Void{
		_createDateTime = a;
	}
	
	public function get readOnly():Boolean{
		return _readOnly;
	}
	
	public function set readOnly(a:Boolean):Void{
		_readOnly = a;
	}
	
	public function get validDesign():Boolean{
		return _validDesign;
	}
	
	public function set validDesign(a:Boolean):Void{
		_validDesign = a;
	}
	
	public function get maxID():Number{
		return _maxID;
	}
	
	public function set maxID(a:Number):Void{
		_maxID = a;
	}	public function get firstActivityID():Number{
		return _firstActivityID;
	}
	
	public function set firstActivityID(a:Number):Void{
		_firstActivityID = a;
	}	public function get activities():Hashtable{
		return _activities;
	}
	
	public function set activities(a:Hashtable):Void{
		_activities = a;
	}

	public function get transitions():Hashtable{
		return _transitions;
	}
	
	public function set transitions(a:Hashtable):Void{
		_transitions = a;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newcopyTypeID 
	 * @return  
	 */
	public function set copyTypeID (newcopyTypeID:Number):Void {
		_copyTypeID = newcopyTypeID;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get copyTypeID ():Number {
		return _copyTypeID;
	}
	
	
	/**
	 * 
	 * @usage   
	 * @param   newlastModifiedDateTime 
	 * @return  
	 */
	public function set lastModifiedDateTime (newlastModifiedDateTime:Date):Void {
		_lastModifiedDateTime = newlastModifiedDateTime;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get lastModifiedDateTime ():Date {
		return _lastModifiedDateTime;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newdateReadOnly 
	 * @return  
	 */
	public function set dateReadOnly (newdateReadOnly:Date):Void {
		_dateReadOnly = newdateReadOnly;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get dateReadOnly ():Date {
		return _dateReadOnly;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newduration 
	 * @return  
	 */
	public function set duration (newduration:Number):Void {
		_duration = newduration;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get duration ():Number {
		return _duration;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newfirstActivityUIID 
	 * @return  
	 */
	public function set firstActivityUIID (newfirstActivityUIID:Number):Void {
		_firstActivityUIID = newfirstActivityUIID;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get firstActivityUIID ():Number {
		return _firstActivityUIID;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newlicenseID 
	 * @return  
	 */
	public function set licenseID (newlicenseID:Number):Void {
		_licenseID = newlicenseID;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get licenseID ():Number {
		return _licenseID;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newlicenseText 
	 * @return  
	 */
	public function set licenseText (newlicenseText:String):Void {
		_licenseText = newlicenseText;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get licenseText ():String {
		return _licenseText;
	}
	
	/**
	 * 
	 * @usage   
	 * @param   newparentLearningDesignID 
	 * @return  
	 */
	public function set parentLearningDesignID (newparentLearningDesignID:Number):Void {
		_parentLearningDesignID = newparentLearningDesignID;
	}
	/**
	 * 
	 * @usage   
	 * @return  
	 */
	public function get parentLearningDesignID ():Number {
		return _parentLearningDesignID;
	}

	
}