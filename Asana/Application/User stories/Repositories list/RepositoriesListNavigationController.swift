//
//  RepositoriesListNavigationController.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class RepositoriesListNavigationController: UINavigationController {

    weak var repositoriesList: RepositoriesListController?
    var repositoriesListDataProvider: RepositoriesListDataProvider?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if repositoriesList == nil {
            repositoriesList = viewControllers[0] as? RepositoriesListController
            repositoriesList?.dataProvider = repositoriesListDataProvider
        }
    }

}
