<?php

/**
 * Implements hook_install_tasks().
 */
function rotary_install_tasks($install_state) {
  return array(
    // Just a hidden task callback.
    'rotary_profile_setup' => array(),
    'rotary_block_setup' => array(),
  );
}

/**
 * Installer task callback.
 */
function rotary_block_setup() {

  $default_theme = 'omega_rotary';
  $admin_theme = 'seven';

  $values = array(
    array(
      'module' => 'simplenews',
      'delta' => 'Newsletter: Multi Subscription',
      'theme' => $default_theme,
      'status' => 1,
      'weight' => 0,
      'region' => 'sidebar_second',
      'pages' => '',
      'cache' => -1,
    ),
  );
  $query = db_insert('block')->fields(array('module', 'delta', 'theme', 'status', 'weight', 'region', 'pages', 'cache'));
  foreach ($values as $record) {
    $query->values($record);
  }
  $query->execute();

}

/**
 * Installer task callback.
 */
function rotary_profile_setup() {

	# SMTP module defaults
	variable_set('smtp_on','1');
	variable_set('smtp_username','crxymail');
	variable_set('smtp_password','crxy010#');
	variable_set('smtp_port','587');
	variable_set('smtp_host','smtp.earthclick.net');
	variable_set('smtp_fromname','Rotary');
	variable_set('smtp_from','aegir@aegir.earthclick.net');

	// create Vocabularies
	# rotary_create_taxonomy('PHF','phf','Paul Harris Fellow designations','Enter a valid PHF description');
 #	rotary_create_taxonomy('Classification','classification','Employment Classification','Enter a valid classification');
#	rotary_create_taxonomy('Committee Type','committee_type','Committee Type','Enter a valid committee type');
#	rotary_create_taxonomy('Location','location','Address and Phone locations','Enter a location');
#	rotary_create_taxonomy('Member Status','member_status','Member Status','Enter member status description'); 
#	rotary_create_taxonomy('Officers','officers','Club Officers','Enter club officers'); 
#	rotary_create_taxonomy('Phone Types','phone_types','Type of phone number','Enter the type of phone number');
#	rotary_create_taxonomy('Project Type','project_type','Project Type','Enter a valid project type');
#	rotary_create_taxonomy('Title','title','Member Title','Enter an optional title for the member');

	// create PHF list
	rotary_create_taxonomy_term('Sustaining', 'phf');
	rotary_create_taxonomy_term('Paul Harris Fellow', 'phf');
	rotary_create_taxonomy_term('PHF Multiple', 'phf');

	// phone/address locations
	rotary_create_taxonomy_term('Billing', 'location');
	rotary_create_taxonomy_term('Home', 'location');
	rotary_create_taxonomy_term('Mailing', 'location');
	rotary_create_taxonomy_term('Other', 'location');
	rotary_create_taxonomy_term('Work', 'location');

	// phone type
	rotary_create_taxonomy_term('Phone', 'phone_types');
	rotary_create_taxonomy_term('Cell', 'phone_types');
	rotary_create_taxonomy_term('Fax', 'phone_types');
	rotary_create_taxonomy_term('Message', 'phone_types');
	rotary_create_taxonomy_term('Pager', 'phone_types');
	rotary_create_taxonomy_term('Toll Free', 'phone_types');

    	// committee Types
	rotary_create_taxonomy_term('Committee', 'committee_type');

    	// Project Types
	rotary_create_taxonomy_term('Community Service', 'project_type');
	rotary_create_taxonomy_term('Fund Raiser', 'project_type');
	rotary_create_taxonomy_term('World Service', 'project_type');

    	// club officers
	rotary_create_taxonomy_term('President', 'officers');
	rotary_create_taxonomy_term('President Elect', 'officers');
	rotary_create_taxonomy_term('President Nominee', 'officers');
	rotary_create_taxonomy_term('Past President', 'officers');
	rotary_create_taxonomy_term('Secretary', 'officers');
	rotary_create_taxonomy_term('Treasurer', 'officers');
	rotary_create_taxonomy_term('Sergeant at Arms', 'officers');

    	// Member Status
	rotary_create_taxonomy_term('Charter Member', 'member_status');
	rotary_create_taxonomy_term('Active', 'member_status');
	rotary_create_taxonomy_term('Honorary', 'member_status');
	rotary_create_taxonomy_term('Inactive', 'member_status');
	rotary_create_taxonomy_term('Former Member', 'member_status');

    	// Member Title
	rotary_create_taxonomy_term('Miss', 'title');
	rotary_create_taxonomy_term('Mr', 'title');
	rotary_create_taxonomy_term('Ms', 'title');
	rotary_create_taxonomy_term('Mrs', 'title');
	rotary_create_taxonomy_term('Sir', 'title');
  
    // attendance
    rotary_create_taxonomy_term_custom('Absent', 'attendance', 'Absent');
    rotary_create_taxonomy_term_custom('Excused', 'attendance', 'Do Not Count');
    rotary_create_taxonomy_term_custom('Makeup', 'attendance', 'Makeup');
    rotary_create_taxonomy_term_custom('Regular Meeting', 'attendance', 'Present');

    // event type
    rotary_create_taxonomy_term('Meeting', 'event_type');
    rotary_create_taxonomy_term('Board Meeting', 'event_type');
    rotary_create_taxonomy_term('Committee Meeting', 'event_type');
    rotary_create_taxonomy_term('Social', 'event_type');

  // Dues Application Rule
  _create_taxonomy_term('Anniversary', 'dues_application_rule');
  _create_taxonomy_term('Policy Date', 'dues_application_rule');

  // Membership Renewal
  _create_taxonomy_term('Automatic', 'membership_renewal','Membership is automatically renewed following payment of dues');
  _create_taxonomy_term('Membership', 'membership_renewal','Membership at large votes on renewal before it is official');
  _create_taxonomy_term('Officers', 'membership_renewal','Renewal requires approval by chapter/club officers or board');
  _create_taxonomy_term('Not Renewable', 'membership_renewal','Membership is not renewable');

}
/*
 * Create taxonomy vocabulary
*/
function rotary_create_taxonomy($name,$machine_name,$description,$help) {
  $vocabulary = (object) array(
    'name' => $name,
    'description' => $description,
    'machine_name' => $machine_name,
    'help' => $help,
  );
  taxonomy_vocabulary_save($vocabulary);

}

/*
 * Create taxonomy terms give machine name ($mac)
 */
function _create_taxonomy_term($name,$machine_name,$description = NULL) {
  $voc = taxonomy_vocabulary_machine_name_load($machine_name);
  $term = new stdClass();
  $term->name = $name;
  if (isset($voc)) {
  	$term->vid = $voc->vid;
  } else {
    	$term->vid = 1;
  }
  if (isset($description)) {
     $term->description = $description;
  }
  taxonomy_term_save($term);
  return $term->tid;
}

/*
 * Create taxonomy terms give machine name ($mac)
 */
function _create_taxonomy_term_custom($name,$machine_name,$statistic) {
  $voc = taxonomy_vocabulary_machine_name_load($machine_name);
  $term = new stdClass();
  $term->name = $name;
  if (isset($statistic)) {
    $term->statistic['und'][0]['value'] = $statistic;
  }
  if (isset($voc)) {
        $term->vid = $voc->vid;
  } else {
        $term->vid = 1;
  }
  taxonomy_term_save($term);
  return $term->tid;
}

