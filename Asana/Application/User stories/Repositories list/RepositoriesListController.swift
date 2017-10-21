//
//  RepositoriesListController.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class RepositoriesListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var dataProvider: RepositoriesListDataProvider?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("not implemented yet")
    }
    
}

class RepositoriesListDataProvider {
    
    let searchService: RepoSearchService
    
    init(searchService: RepoSearchService) {
        self.searchService = searchService
    }
    
}
