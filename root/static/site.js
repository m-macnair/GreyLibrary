
function get_url(this_url){
	var xhr = new XMLHttpRequest(); 		
	/* async is the default here, causing newb problems */
	xhr.open("GET", this_url, false);
	xhr.send();
	return xhr.response;
}


function send_tag_string(tag_string,id) {
	get_url("/image/api/tag_file/" + id + "/" + tag_string); 
}

async function async_get_url (this_url) {
	const response = await fetch(this_url);
	return response;
}

function safelyParseJSON(jsonString) {
	
	try { 
		var data = JSON.parse(jsonString);
		//console.log("Parsed data:", data);
		return data;
	} catch (error) { console.log("Error parsing JSON:", error);
} }
