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
First of all, include SPMobile.h in each page where you're using the library.


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


License
-

(The MIT License)


Copyright (C) 2013 James Love

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
