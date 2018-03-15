//
//  CT_RESTConstants.swift
//  CT_RESTAPI
//
//  Created by thcanh on 3/2/17.
//  Copyright © 2017 CanhTran. All rights reserved.
//

import Foundation

public struct RESTContants {
    
    //MARK: Keys for parser
    static let kDefineSuccessKeyFromResponseData        = "status"
    static let kDefineMessageKeyFromResponseData        = "message"
    static let kDefineDefaultMessageKeyFromResponseData = "unknow_error"
    
    //MARK: Prepairing request
    static let kDefineRequestTimeOut                    = 90.0
    static let kDefineStatusCodeSuccess                 = 200
    
    //MARK: Webservice url
    #if DEBUG
        static let kDefineWebserviceUrl                 = "https://s3-us-west-2.amazonaws.com/"
    #else
        static let kDefineWebserviceUrl                 = "https://s3-us-west-2.amazonaws.com/"
    #endif

    #if DEBUG
        public static let kDefineWebserviceResourceUrl             = "https://s3-us-west-2.amazonaws.com/"
    #else
        public static let kDefineWebserviceResourceUrl             = "https://s3-us-west-2.amazonaws.com/"
    #endif
    
    static let headers                                  = ["Content-Type" : "application/json"]
}

public enum StatusCode: NSInteger {
    case success = 200
}

public enum RequestMethod : String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

public enum Endcoding : String {
    case URL, JSON, CUSTOM
}


public enum RESTRequestBodyType {
    case json
    case form
}
