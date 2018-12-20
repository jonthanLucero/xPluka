//
//  TPValidations.swift
//  xPluka
//
//  Created by Peter Arcentales on 12/14/18.
//  Copyright © 2018 Inalambrilk. All rights reserved.
//

import Foundation

public class TPValidations {
    //Validates if there are required data not filled
    public func validateTPRegisterData(_ name:String,_ description:String,_ type: String,_ qualification: String) -> String
    {
        var errorMessage:String = ""
        
        if (name.isEmpty)
        {
            errorMessage="Name"
        }
        
        if (description.isEmpty)
        {
            errorMessage+=",Description"
        }
        
        if (type.isEmpty)
        {
            errorMessage+=",Type"
        }
        
        if (qualification.isEmpty)
        {
            errorMessage+=",Qualification"
        }
        
        if(!errorMessage.isEmpty)
        {
            errorMessage+=" required."
        }
        return errorMessage
    }
    
    //Validates if was registered a correct type Of Touristic Place
    public func validateTPType(_ type: String) -> Bool
    {
        let typeUpperCased = type.uppercased()
        var tpTypeStatus:Bool = true
        if(typeUpperCased != tpStructures.beach && typeUpperCased != tpStructures.forest && typeUpperCased != tpStructures.lake && typeUpperCased != tpStructures.mountain)
        {
            tpTypeStatus = false
        }
        return tpTypeStatus
    }
    
    //Validates if the registered qualification is valid (1 - 10)
    public func validateTPQualification(_ qualification: Int) -> Bool
    {
        var tpQualificationStatus:Bool = true
        if(qualification < 1 || qualification > 10)
        {
            tpQualificationStatus = false
        }
        return tpQualificationStatus
    }
    
    //Validates if there are required data not filled in the Register Visit
    public func validateVisitRegisterData(_ touristicPlaceName:String,_ startDate: String,_ startTime: String,_ endDate: String,_ endTime: String) -> String
    {
        var errorMessage:String = ""
        
        if (touristicPlaceName.isEmpty)
        {
            errorMessage="Touristic Place"
        }
        
        if (startDate.isEmpty)
        {
            errorMessage+=",Start Date"
        }
        
        if (startTime.isEmpty)
        {
            errorMessage+=",Start Time"
        }
        
        if (endDate.isEmpty)
        {
            errorMessage+=",End Date"
        }
        
        if (endTime.isEmpty)
        {
            errorMessage += ",End Time"
        }
        
        if(!errorMessage.isEmpty)
        {
            errorMessage+=" required."
        }
        return errorMessage
    }
    
    //Validates if was registered a correct type Of Touristic Place
    public func validateVisitDateTime(_ startDateTime: Date, endDateTime: Date) -> String
    {
        var visitDateTimeStatus:String = ""
        if(startDateTime == endDateTime)
        {
            visitDateTimeStatus += "Start and End DateTime must be different"
        }
        else
        {
            if(startDateTime > endDateTime)
            {
                visitDateTimeStatus += "End DateTime must be greater than Start DateTime"
            }
        }
        return visitDateTimeStatus
    }
    
}
