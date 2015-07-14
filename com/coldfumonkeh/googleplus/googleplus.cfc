<!---
Name: googleplus.cfc
Author: Matt Gifford aka coldfumonkeh (http://www.mattgifford.co.uk)
Date: 11.11.2011

Copyright 2011 Matt Gifford aka coldfumonkeh. All rights reserved.
Product and company names mentioned herein may be
trademarks or trade names of their respective owners.

Subject to the conditions below, you may, without charge:

Use, copy, modify and/or merge copies of this software and
associated documentation files (the 'Software')

Any person dealing with the Software shall not misrepresent the source of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


Got a lot out of this package? Saved you time and money? 

Share the love and visit Matt’s wishlist: 

http://www.amazon.co.uk/wishlist/B9PFNDZNH4PY 

================


Revision history
================

11.11.2011 - Version 0.8

	- initial release of API. Currently without OAuth implementation.

--->
<cfcomponent name="googleplus" output="false" hint="I am the Google Plus API object.">
	
	<cfset variables.instance = {} />
	
	<cffunction name="init" access="public" output="false" hint="I am the constructor method.">
		<cfargument name="apiKey" 			required="true" 	type="string" 					hint="I am the application's API key to access the services." />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="false"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset variables.instance.apikey		=	arguments.apiKey />
			<cfset variables.instance.parseResults	=	arguments.parseResults />
			<cfset variables.instance.endpoint		=	'https://www.googleapis.com/plus/v1/' />
		<cfreturn this />
	</cffunction>
		
	<!--- Getters / Accessors --->
	<cffunction name="getparseResults" access="package" output="false" hint="I return the parseresults boolean value.">
		<cfreturn variables.instance.parseResults />
	</cffunction>
	
	<!--- PEOPLE --->
		
	<!---
		People is a list of person resources, each of which represents a Google+ user. 
		People methods enable your application to get a person's profile, search through profiles, and list all of the people who have +1'd or reshared a particular activity. 
		Each person has an uniquely identifying ID.
	--->
		
	<cffunction name="people_get" access="public" output="false" hint="I get a person's profile.">
		<cfargument name="userID" 			required="true" 	type="string" 									hint="The ID of the person to get the profile for. The special value 'me' can be used to indicate the authenticated user." />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'people/' & arguments.userID & '?key=' & variables.instance.apikey />
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<cffunction name="people_search" access="public" output="false" hint="I search all public profiles. For large result sets, results are paginated. For the most up-to-date search results, do not use a pageToken older than five minutes — instead, restart pagination by repeating the original request (omitting pageToken).">
		<cfargument name="query" 			required="true" 	type="string" 									hint="Full-text search query string." />
		<cfargument name="maxResults" 		required="false" 	type="numeric" 	default="10" 					hint="The maximum number of people to include in the response, used for paging. For any response, the actual number returned may be less than the specified maxResults. Acceptable values are 1 to 20, inclusive. (Default: 10)." />
		<cfargument name="pageToken" 		required="false" 	type="string" 	default="" 						hint="The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of 'nextPageToken' from the previous response. This token may be of any length." />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'people' & '?key=' & variables.instance.apikey & '&' & buildParamString(arguments) />		
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<cffunction name="people_listByActivity" access="public" output="false" hint="I list all of the people in the specified collection for a particular activity. The collection parameter specifies which people to list, such as people who have +1'd or reshared this activity. For large collections, results are paginated. Each item in the response of this method contains basic fields of a person resource, including id, displayName, image, and url. To get a full person resource, use people.get.">
		<cfargument name="activityId" 		required="true" 	type="string" 									hint="The ID of the activity to get the list of people for." />
		<cfargument name="collection" 		required="true" 	type="string" 									hint="The collection of people to list. Acceptable values are: 'plusoners' - List all people who have +1'd this activity. 'resharers' - List all people who have reshared this activity." />
		<cfargument name="maxResults" 		required="false" 	type="numeric" 	default="20" 					hint="The maximum number of people to include in the response, used for paging. For any response, the actual number returned may be less than the specified maxResults. Acceptable values are 1 to 100, inclusive. (Default: 20)." />
		<cfargument name="pageToken" 		required="false" 	type="string" 	default="" 						hint="The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of 'nextPageToken' from the previous response." />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'activities/' & arguments.activityId & '/people/' & arguments.collection & '?key=' & variables.instance.apikey & '&' & buildParamString(arguments) />		
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<!--- END PEOPLE --->
		
	<!--- ACTIVITIES --->
	
	<!---
		An activity is a note that a user posts to their stream. 
		Activity methods enable your application to list a collection of activities, get an activity and search through activities.	
	--->
		
	<cffunction name="activities_get" access="public" output="false" hint="I get an activity.">
		<cfargument name="activityID" 		required="true" 	type="string" 									hint="The ID of the activity to get." />
		<cfargument name="alt" 				required="false" 	type="string" 	default="json" 					hint="Specifies an alternative representation type. Acceptable values are: 'json' - Use JSON format (default)." />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'activities/' & arguments.activityID & '?key=' & variables.instance.apikey & '&' & buildParamString(arguments) />
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<cffunction name="activities_list" access="public" output="false" hint="I list all of the activities in the specified collection for a particular user. The collection parameter specifies which activities to list, such as public activities. For large collections, results are paginated.">
		<cfargument name="userID" 			required="true" 	type="string" 									hint="The ID of the user to get activities for. The special value 'me' can be used to indicate the authenticated user." />
		<cfargument name="collection" 		required="false" 	type="string" 	default="public"				hint="The collection of activities to list. Acceptable values are: 'public' - All public activities created by the specified user." />
		<cfargument name="alt" 				required="false" 	type="string" 	default="json" 					hint="Specifies an alternative representation type. Acceptable values are: 'json' - Use JSON format (default)." />
		<cfargument name="maxResults" 		required="false" 	type="numeric" 	default="20" 					hint="The maximum number of activities to include in the response, used for paging. For any response, the actual number returned may be less than the specified maxResults. Acceptable values are 1 to 100, inclusive. (Default: 20)."  />
		<cfargument name="pageToken" 		required="false" 	type="string" 	default="" 						hint="The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of 'nextPageToken' from the previous response."  />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'people/' & arguments.userID & '/activities/' & arguments.collection & '?key=' & variables.instance.apikey & '&' & buildParamString(arguments) />
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<cffunction name="activities_search" access="public" output="false" hint="I search public activities. For large result sets, results are paginated. For the most up-to-date search results, do not use a pageToken older than five minutes — instead, restart pagination by repeating the original request (omitting pageToken).">
		<cfargument name="query" 			required="true" 	type="string" 									hint="Full-text search query string." />
		<cfargument name="maxResults" 		required="false" 	type="numeric" 	default="10" 					hint="The maximum number of activities to include in the response, used for paging. For any response, the actual number returned may be less than the specified maxResults. Acceptable values are 1 to 20, inclusive. (Default: 10)."  />
		<cfargument name="orderBy" 			required="false" 	type="string" 	default="recent" 				hint="Specifies how to order search results. Acceptable values are: 'best' - Sort activities by relevance to the user, most relevant first. 'recent' - Sort activities by published date, most recent first. (default)."  />
		<cfargument name="pageToken" 		required="false" 	type="string" 	default="" 						hint="The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of 'nextPageToken' from the previous response. This token may be of any length."  />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'activities?key=' & variables.instance.apikey & '&' & buildParamString(arguments) />
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<!--- END ACTIVITIES --->
		
	<!--- COMMENTS --->
		
	<!---
		A comment is a reply to an activity. 
		Comment methods enable your application to list a collection of comments and get a comment.
	--->
	
	<cffunction name="comments_get" access="public" output="false" hint="I get a comment.">
		<cfargument name="commentID" 		required="true" 	type="string" 									hint="The ID of the comment to get." />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'comments/' & arguments.commentID & '?key=' & variables.instance.apikey />
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
	
	<cffunction name="comments_list" access="public" output="false" hint="I list all of the comments for an activity. For large collections, results are paginated.">
		<cfargument name="activityID" 		required="true" 	type="string" 									hint="The ID of the activity to get comments for." />
		<cfargument name="alt" 				required="false" 	type="string" 	default="json" 					hint="Specifies an alternative representation type. Acceptable values are: 'json' - Use JSON format (default)."  />
		<cfargument name="maxResults" 		required="false" 	type="numeric" 	default="20" 					hint="The maximum number of comments to include in the response, used for paging. For any response, the actual number returned may be less than the specified maxResults. Acceptable values are 1 to 100, inclusive. (Default: 20)."  />
		<cfargument name="pageToken" 		required="false" 	type="string" 	default="" 						hint="The continuation token, used to page through large result sets. To get the next page of results, set this parameter to the value of 'nextPageToken' from the previous response."  />
		<cfargument name="parseResults"		required="false" 	type="boolean" 	default="#getparseResults()#"	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var strRequest	=	variables.instance.endpoint & 'activities/' & arguments.activityID & '/comments?key=' & variables.instance.apikey & '&' & buildParamString(arguments) />
		<cfreturn getRequest(URLResource=strRequest, parseResults=arguments.parseResults) />
	</cffunction>
		
	<!--- END COMMENTS --->
		
	<!--- Utils --->
	<cffunction name="getRequest" access="private" output="false" hint="I make the GET request to the API.">
		<cfargument name="URLResource" 	required="true" type="string" 	hint="I am the URL to which the request is made." />
		<cfargument name="parseResults"	required="true" type="boolean" 	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfset var cfhttp	=	'' />
				<cfhttp url="#arguments.URLResource#" method="get" />
		<cfreturn handleReturnFormat(data=cfhttp.FileContent, parseResults=arguments.parseResults) />
	</cffunction>
	
	<cffunction name="handleReturnFormat" access="private" output="false" hint="I handle how the data is returned based upon the provided format">
		<cfargument name="data" 		required="true" type="string" 	hint="The data returned from the API." />
		<cfargument name="parseResults"	required="true" type="boolean" 	hint="A boolean value to determine if the output data is parsed or returned as a string" />
			<cfif arguments.parseResults>
				<cfreturn DeserializeJSON(arguments.data) />
			<cfelse>
				<cfreturn serializeJSON(DeserializeJSON(arguments.data)) />
			</cfif>
	</cffunction>
	
	<cffunction name="buildParamString" access="private" output="false" returntype="String" hint="I loop through a struct to convert to query params for the URL">
		<cfargument name="argScope" required="true" type="struct" hint="I am the struct containing the method params" />
			<cfset var strURLParam 	= '' />
			<cfloop collection="#arguments.argScope#" item="key">
				<cfif len(arguments.argScope[key])>
					<cfif listLen(strURLParam)>
						<cfset strURLParam = strURLParam & '&' />
					</cfif>	
					<cfset strURLParam = strURLParam & lcase(key) & '=' & arguments.argScope[key] />
				</cfif>
			</cfloop>
		<cfreturn strURLParam />
	</cffunction>
	
	<cffunction name="clearEmptyParams" access="private" output="false" hint="I accept the structure of arguments and remove any empty / nulls values before they are sent to the OAuth processing.">
		<cfargument name="paramStructure" required="true" type="Struct" hint="I am a structure containing the arguments / parameters you wish to filter." />
			<cfset var stuRevised = {} />
				<cfloop collection="#arguments.paramStructure#" item="key">
					<cfif len(arguments.paramStructure[key])>
						<cfset structInsert(stuRevised, lcase(key), arguments.paramStructure[key], true) />
					</cfif>
				</cfloop>
		<cfreturn stuRevised />
	</cffunction>
	
</cfcomponent>