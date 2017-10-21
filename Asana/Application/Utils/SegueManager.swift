//
//  SegueManager.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit
import Rswift

public class SegueManager {
    
    public typealias Handler = (UIStoryboardSegue) -> Void
    private unowned let viewController: UIViewController
    private var handlers = [String: Handler]()
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func prepare(for segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier, let handler = handlers[identifier] else { return }
        
        handler(segue)
        handlers.removeValue(forKey: identifier)
    }
    
    public func performSegue(withIdentifier identifier: String, handler: @escaping Handler = { _ in }) {
        onSegue(withIdentifier: identifier, do: handler)
        viewController.performSegue(withIdentifier: identifier, sender: viewController)
    }
    
    public func onSegue(withIdentifier identifier: String, do handler: @escaping Handler) {
        handlers[identifier] = handler
    }
    
}

public protocol SeguePerformer {
    
    var segueManager: SegueManager { get }
    
}

public extension SeguePerformer {
    
    public func performSegue<Source, Destination>(
        _ segueIdentifier: StoryboardSegueIdentifier<UIStoryboardSegue, Source, Destination>,
        handler: @escaping (TypedStoryboardSegueInfo<UIStoryboardSegue, Source, Destination>) -> Void = { _ in }) {
        
        segueManager.performSegue(withIdentifier: segueIdentifier.identifier) { segue in
            handler(TypedStoryboardSegueInfo(segueIdentifier: segueIdentifier, segue: segue)!)
        }
    }
    
    public func onSegue<Source, Destination>(
        _ segueIdentifier: StoryboardSegueIdentifier<UIStoryboardSegue, Source, Destination>,
        handler: @escaping (TypedStoryboardSegueInfo<UIStoryboardSegue, Source, Destination>) -> Void = { _ in }) {
        
        segueManager.onSegue(withIdentifier: segueIdentifier.identifier) { (segue) in
            handler(TypedStoryboardSegueInfo(segueIdentifier: segueIdentifier, segue: segue)!)
        }
    }
    
}
