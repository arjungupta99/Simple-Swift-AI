//
//  CoreDataUtil.swift
//  Simple-Swift-AI
//
//  Created by Arjun Gupta on 10/2/16.
//  Copyright © 2016 Arjun Gupta. All rights reserved.
//

import Foundation
import CoreData

class CoreDataUtil {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Simple_Swift_AI")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                
                fatalError("Error: \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        
        context.reset()
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                
                fatalError("Error: \(error), \(error.userInfo)")
            }
        }
    }
    
    
    func persistNewWeights(neurons:[[NeuronA]], persistanceID:String) {
        
        let context     = persistentContainer.viewContext
        var layers      = [[[String:Double]]]()
        for layer in neurons {
            
            var aLayer = [[String:Double]]()
            for neuron in layer {
                var inputIdentifiers = [String:Double]()
                for input in neuron.inputs {
                    inputIdentifiers[input.key] = input.value.weight
                }
                aLayer.append(inputIdentifiers)
            }
            layers.append(aLayer)
        }
        
        
        let nObj            = NetworkObj(context: context)
        nObj.persistanceID  = persistanceID
        let arrayData       = NSKeyedArchiver.archivedData(withRootObject: layers)
        nObj.neurons        = arrayData as NSData?
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save context: \(error)")
        }
        
    }
    
    
    func fetchExistingWeights(persistanceID:String) -> [[[String:Double]]]? {
        
        let context     = persistentContainer.viewContext
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "NetworkObj")
        
        request.predicate = NSPredicate(format: "persistanceID == %@", persistanceID)
        
        var result:[[[String:Double]]]?
        do {
            let results = try context.fetch(request)
            if let res = results.last {
                if let arr = res as? NetworkObj {
                    
                    //DebugLog("nObj.objectID acc : \(arr.objectID.description)")
                    if let ar =  NSKeyedUnarchiver.unarchiveObject(with: arr.neurons! as Data) as? [[[String:Double]]] {
                        
                        result = ar
                    }
                }
            }
            
        } catch let error as NSError {
            print("Failure to fetch \(error), \(error.userInfo)")
        }
        
        return result
    }
    
}
