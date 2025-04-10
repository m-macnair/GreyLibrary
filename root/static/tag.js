

function send_tag_string(tag_string,subject_id) {
	get_url("/subject/api/tag_subject/" + subject_id + "/" + tag_string); 
}

function want(subject_id) {
	send_tag_string('want',subject_id);
	used_button("want_button");
}
function problem(subject_id) {
	send_tag_string('problem',subject_id);
	used_button("problem_button");
}

function keep(subject_id) {
	send_tag_string('keep',subject_id);
	used_button("keep_button");
}

function toss(subject_id) {
	send_tag_string('toss',subject_id);
	used_button("toss_button");
}

function lewd(subject_id) {
	send_tag_string('lewd',subject_id);
	used_button("lewd_button");
}


function tag_button (tag_string,subject_id) { 
	send_tag_string(tag_string,subject_id);
	used_button(tag_string + "_button");
}

function used_button (button_id_string) { 
	this_button = document.getElementById(button_id_string);
	this_button.disabled = true;
	this_button.style.backgroundColor = "orange";
}
