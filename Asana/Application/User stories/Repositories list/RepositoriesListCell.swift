//
//  RepositoriesListCell.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class RepositoriesListCell: UITableViewCell, ListCell, UpdatableListCell {

    static let reuseIdentifier = R.reuseIdentifier.repositoriesListCell
    static let nib = R.nib.repositoriesListCell

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    
    func update(withViewModel model: RepositoriesListCellViewModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        forksLabel.text = model.forks
    }

}

struct RepositoriesListCellViewModel {
    
    let name: String
    let description: String
    let forks: String
    
    init(repo: Repo) {
        self.name = repo.fullName
        self.description = repo.description ?? ""
        self.forks = String.init(format: "%@: %i", NSLocalizedString("Forks", comment: ""), repo.forksCount)
    }
}
