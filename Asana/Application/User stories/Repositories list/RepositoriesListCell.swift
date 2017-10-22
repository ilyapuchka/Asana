//
//  RepositoriesListCell.swift
//  Asana
//
//  Created by Ilya Puchka on 21/10/2017.
//  Copyright © 2017 Ilya Puchka. All rights reserved.
//

import UIKit

class RepositoriesListCell: UITableViewCell, ListCell {

    static let reuseIdentifier = R.reuseIdentifier.repositoriesListCell
    static let nib = R.nib.repositoriesListCell

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    
    private var imageLoadindHandle: UUID?
    
    func update(withViewModel model: RepositoriesListCellViewModel) {
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        forksLabel.text = model.forks
        
        imageLoadindHandle = ImageLoader.shared.getImage(model.avatar) { [weak self] handle, image, _ in
            guard handle == self?.imageLoadindHandle else { return }
            self?.avatarView.image = image
        }
    }

    override func prepareForReuse() {
        if let imageLoadindHandle = imageLoadindHandle {
            ImageLoader.shared.cancelImageLoading(imageLoadindHandle)
            self.imageLoadindHandle = nil
        }
        avatarView.image = nil
    }
}

struct RepositoriesListCellViewModel {
    
    let name: String
    let description: String
    let forks: String
    let avatar: URL
    
    init(repo: Repo) {
        self.name = repo.fullName
        self.description = repo.description ?? ""
        self.forks = String(format: "%@: %i", NSLocalizedString("Forks", comment: ""), repo.forksCount)
        self.avatar = repo.owner.avatarURL
    }
}
