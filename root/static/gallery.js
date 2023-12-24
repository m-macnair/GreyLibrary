function want(id) {
	send_tag_string('want',id);
	post_tag(id);
}
function problem(id) {
	send_tag_string('problem',id);
	post_tag(id);
}

function keep(id) {
	send_tag_string('keep',id);
	post_tag(id);
}

function toss(id) {
	send_tag_string('toss',id);
	post_tag(id);
}

function post_tag(id){
	del_div(id);
	get_more(5);
}

function get_more(offset){
	// Specify the URL for fetching HTML
	var url = "/image/api/get_untagged_four_cell/" + offset ;

	// Get the existing div element by its id
	var div = document.getElementById("gallery_div");

	// Create a new XMLHttpRequest object
	var xhr = new XMLHttpRequest();

	// Configure the request
	xhr.open("GET", url, true);

	// Set the response type to "document" to treat it as HTML
	xhr.responseType = "document";

	// Define the callback function for when the request is completed
	xhr.onload = function() {
		if (xhr.status === 200) {
			// Access the retrieved HTML document
			var html = xhr.response;

			// Get the content container element from the retrieved HTML
			var content = html.getElementById("cell");

			// Append the content to the existing div
			div.appendChild(content);
		} else {
			console.error("Request failed. Status: " + xhr.status);
		}
	};
	xhr.send();

}

function del_div(id){
	var div = document.getElementById("cell_" + id );
	if (div) {
		div.remove();
	} else {
		console.log("Element not found!");
	}
}
