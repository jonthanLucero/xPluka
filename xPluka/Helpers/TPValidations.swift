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
    
    
    
    
}
