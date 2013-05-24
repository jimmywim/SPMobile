SPMobile
========

SPMobile is an iOS library for simplifying the process of connectiong to and querying Microsoft SharePoint sites.

This version supports:
* Office 365 SharePoint Online sites
* "On-premises" deployments using FBA Authentication
* SharePoint 2013 _api (Office 365 only)
* "Classic" .asmx web services (SP2007/SP2010/SP2013)

Usage
-----

    Authentication *auth;
    
    // This authenticates to SharePoint Online
    auth = [[SPOAuthentication alloc] initWithUsernamePasswordSite:username password:password site:siteUrl];
    
    // This authenticates using FBA
    auth = [[FormsAuth alloc] initWithUsernamePasswordSite:username password:password site:siteUrl];
    [auth setAuthdelegate:self];
    [auth authenticate];
    
    
Authentication Delegates
-

    - (void)authentication: (SPAuthentication *)didAuthenticate
    {
      // Do something cool now we're logged in
    }

    - (void)authentication: (SPAuthentication *)didFailWithError: (NSError *)error
    {
      // Do something helpful as Auth failed for some reason.
    }
    


Querying SharePoint (SP2013 _api example)
-

    NSString* urlRequest = @"http://somesharepointsite/sites/myweb/_api/web/Title";
    NSString* requestIdStr = @"TitleRequest"
    NSMutableString* requestMethod = @"GET"
    
    RemoteQuery* query = [[RemoteQuery alloc] initWithUrlRequestId:urlRequest id:requestId];
    [query setDelegate:self];
    [query setRequestMethod:requestMethod];
    [query setIncludeFormDigest:false];
    
    [query executeQuery];
    
Querying SharePoint (SP2007/SP2010/SP2013 classic web services)
-
    NSString* urlRequest = @"http://somesharepointsite/sites/TeamSite/_vti_bin/Lists.asmx";
    NSString* requestIdStr = @"AllListsRequest";
    NSMutableString* requestMethod = @"POST";
    NSString* payload = @"<<FULL SOAP PACKET OF REQUEST HERE>>";
    NSString* soapAction = @"http://schemas.microsoft.com/sharepoint/soap/GetListCollection";
    
    RemoteQuery* query = [[RemoteQuery alloc] initWithUrlRequestId:urlRequest id:requestId];
    [query setDelegate:self];
    [query setRequestMethod:requestMethod];
    [query setIncludeFormDigest:false];
    
    if([payload length] > 0)
        [query setPayload:payload];
    
    if([soapAction length] > 0)
        [query setSoapAction:soapAction];
    
    [query executeQuery];
    
    
Query Response Delegate Methods
-

    - (void)RemoteQuery:(id)RemoteQuery didCompleteQueryWithRequestId:(NSString *)result requestId:(NSString *)requestId
    {
      // Do something here with 'result', it contains the response as a string
      // requestID can be used to differentriate multiple queries that happen in quick succession
    }

    - (void)RemoteQuery: (id)RemoteQuery didCompleteWithAuthFailure:(NSError *)error
    {
      // Either bail back to the client (probably easier) or internally log back in and re-try the query.
      // If we did the latter, it might be difficult to feedback to the client the extra delay.
    }

    - (void)RemoteQuery: (id)RemoteQuery didCompleteWithFailure:(NSError *)error
    {
      // Handle (nicely) the fact that the query failed for some reason.
      // Note that this (should) happens when you have anything other than a 200 or a redirect.
    }
