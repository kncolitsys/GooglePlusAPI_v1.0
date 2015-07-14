
<cfset strAPIkey	=	'< your api key goes here >' />

<cfset objGoogPlus = createObject("component","com.coldfumonkeh.googleplus.googleplus").init(apikey	=	strAPIkey, parseResults	=	true) />

<!---<cfdump var="#objGoogPlus.people_get(userID='109674867658285897675')#">--->

<!---<cfdump var="#objGoogPlus.people_search(query='Forta')#">--->

<!---<cfdump var="#objGoogPlus.people_listByActivity(activityId='z12ielk4lli0wtlug22ksvlrbnvqvnnyc04', collection='plusoners')#">--->

<!---<cfdump var="#objGoogPlus.activities_list(userID='109674867658285897675')#">--->

<!---<cfdump var="#objGoogPlus.activities_get(activityId='z12ielk4lli0wtlug22ksvlrbnvqvnnyc04')#">--->

<!---<cfdump var="#objGoogPlus.activities_search(query='ColdFusion')#">--->

<!---<cfdump var="#objGoogPlus.comments_list(activityId='z12acrnzirrqgdwxf04cdrir3pqsyxhjjw40k')#">--->

<!---<cfdump var="#objGoogPlus.comments_get(commentID='pfBABQup2ArBfy5v5QgKNWOxqAO_odxQi7O_MmVJhPKinNauutCbxcrDXlQJk6Zue17T-xk4j6aLGfkUkljXiQ')#">--->