Parse.Cloud.define("match", function(request, response) {  
	var currentUser = Parse.User.current();
	var otherUser = new Parse.User();
 	otherUser.set("objectId", request.params.userID);
  	
  	var query = new Parse.Query("UserLikes"); 
  	query.equalTo("userID", otherUser);
 	query.find({
   
  	success: function(results) {
         
        	var me = currentUser;
      			for (var i = 0; i < results.length; ++i) {
              		var peopleSheLikes = results[i].get("userLiked");
              			if(peopleSheLikes.id == me.id){
                 			var theyMatched = "They fucking match";
                  
                 			var DelightChat = Parse.Object.extend("DelightChat");
                 			var delightChat = new DelightChat();
                 
                			delightChat.set("user1", currentUser);
                			delightChat.set("user2", otherUser);
                  delightChat.save(null, {
                     success: function(delightChat) {
                 // Execute any logic that should take place after the object is saved.
    alert('New object created with objectId: ' + delightChat.id);
                },
                     error: function(delightChat, error) {
 //               // Execute any logic that should take place if the save fails.
 //               // error is a Parse.Error with an error code and message.
    alert('Failed to create new object, with error code: ' + error.message);
                }
              });
 
              }
      }

     
    response.success(theyMatched);
  }, 
  error: function() {
    response.error("movie lookup failed");
  }
 });
});

Parse.Cloud.define("matchFeed", function(request, response) {  
	var currentUser = Parse.User.current();
	var currentUserID = currentUser.id;
  	
  	var query = new Parse.Query(Parse.User); 
 	query.notEqualTo("objectId", request.params.objectId);


 	query.find().then(function (users){
 		var list = [];
 		for(var i = 0; i<users.length; i++){
 			
 			list[i] = users[i].toJSON();
 		}
  		response.success(list);	
  }, function (error) {
        response.error(error);
    });
 
});

