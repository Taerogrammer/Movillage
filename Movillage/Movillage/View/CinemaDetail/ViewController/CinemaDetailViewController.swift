import UIKit

final class CinemaDetailViewController: UIViewController {
    let viewModel = CinemaDetailViewModel()
    private let cinemaDetailView = CinemaDetailView()
    // false -> 3줄 (More Tapped가 false)
    var isMoreTapped = false

    override func loadView() {
        view = cinemaDetailView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        [configureDelegate(), configureNavigation(), favoriteButtonColorChanged(), bindData()].forEach { $0 }
    }
}

// MARK: - bind
extension CinemaDetailViewController {
    private func bindData() {
        viewModel.output.backdropArray.lazyBind { [weak self] array in
            self?.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 0))
        }
        viewModel.output.castDTO.lazyBind { [weak self] data in
            self?.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 2))
        }
        viewModel.output.posterArray.lazyBind { [weak self] array in
            self?.cinemaDetailView.collectionView.reloadSections(IndexSet(integer: 3))
        }
    }
}

// MARK: configure collection view
extension CinemaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.detailSection.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.output.backdropArray.value?.count ?? 0
        case 1:
            return 1
        case 2:
            return viewModel.output.castDTO.value != nil ? viewModel.output.castDTO.value!.count : 0
        case 3:
            return viewModel.output.posterArray.value?.count ?? 0
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.id, for: indexPath) as! BackdropCollectionViewCell

            cell.configureImageCell(with: viewModel.output.backdropArray.value?[indexPath.item])

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SynopsisCollectionViewCell.id, for: indexPath) as! SynopsisCollectionViewCell

            cell.configureCell(with: viewModel.output.synopsisDTO.value)
            cell.synopsisLabel.numberOfLines = isMoreTapped ? 0 : 3

            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.id, for: indexPath) as! CastCollectionViewCell
            if viewModel.output.castDTO.value?.count ?? 0 > 0 {
                guard let castDTO = viewModel.output.castDTO.value else { return cell }
                cell.configureCell(with: castDTO[indexPath.item])
            }

            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.id, for: indexPath) as! PosterCollectionViewCell

            cell.configureImageCell(with: viewModel.output.posterArray.value?[indexPath.item])

            return cell
        default:
            return UICollectionViewCell()
        }
    }

    // header, footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaDetailHeaderView.id, for: indexPath) as! CinemaDetailHeaderView

            header.configureHeaderTitle(title: viewModel.detailSection[indexPath.section])
            header.configureMoreButton(title: viewModel.detailSection[indexPath.section])

            header.moreButtonToggle = {
                self.isMoreTapped.toggle()
                header.moreButton.setTitle(self.isMoreTapped ? "Hide" : "More", for: .normal)
                self.cinemaDetailView.collectionView.reloadItems(at: [indexPath])
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CinemaDetailFooterView.id, for: indexPath) as! CinemaDetailFooterView

            footer.configureCell(with: viewModel.output.footerDTO.value)
            footer.pageControl.numberOfPages = viewModel.output.backdropArray.value?.count ?? 5

            cinemaDetailView.currentPageChanged = { value in
                footer.pageControl.currentPage = value
            }

            return footer
        }
    }
}

// MARK: configure delegate
extension CinemaDetailViewController: DelegateConfiguration {
    func configureDelegate() {
        cinemaDetailView.collectionView.delegate = self
        cinemaDetailView.collectionView.dataSource = self
        cinemaDetailView.collectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.id)
        cinemaDetailView.collectionView.register(SynopsisCollectionViewCell.self, forCellWithReuseIdentifier: SynopsisCollectionViewCell.id)
        cinemaDetailView.collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.id)
        cinemaDetailView.collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.id)
        // header, footer
        cinemaDetailView.collectionView.register(CinemaDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CinemaDetailHeaderView.id)
        cinemaDetailView.collectionView.register(CinemaDetailFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CinemaDetailFooterView.id)
    }
}

// MARK: configure navigation
extension CinemaDetailViewController: NavigationConfiguration {
    func configureNavigation() {
        title = viewModel.output.footerDTO.value.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cinemaDetailView.favoriteButton)
        cinemaDetailView.favoriteButton.addTarget(self, action: #selector(likeBarButtonTapped), for: .touchUpInside)
    }
    private func favoriteButtonColorChanged() {
        let isFavorite = UserDefaultsManager.favoriteMovie.contains(viewModel.output.footerDTO.value.id)
        cinemaDetailView.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart.fill" : "heart"), for: .normal)
    }
}

// MARK: @objc
extension CinemaDetailViewController {
    @objc private func likeBarButtonTapped() {
        CinemaDetailViewController.didFavoriteTapped(id: viewModel.output.footerDTO.value.id)
        favoriteButtonColorChanged()
    }
}
