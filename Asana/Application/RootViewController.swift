//
//  RootViewController.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit
import Rswift

class RootViewController: UIViewController, SeguePerformer {
    
    lazy var segueManager: SegueManager = SegueManager(viewController: self)
    
    weak var repositoriesListNavigationController: RepositoriesListNavigationController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueManager.prepare(for: segue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let searchService = RepoSearchService(repository: APIRepoSearchRepository(networkSession: URLSession.shared))
        let repositoriesListDataProvider = RepositoriesListDataProvider(searchService: searchService)
        
        onSegue(R.segue.rootViewController.installRepositoriesList) { (segue) in
            segue.source.repositoriesListNavigationController = segue.destination
            segue.destination.repositoriesListDataProvider = repositoriesListDataProvider
        }
    }

}
