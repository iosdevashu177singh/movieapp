//
//  MovieListVC.swift
//  MovieApp
//
//  Created by Ashutosh Singh on 03/03/25.
//

import UIKit
import Combine

class MovieListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var backGroundView: GradientBackgroundView!
    
    // MARK: - Properties
    private var viewModel = MovieViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let loaderView = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchBar()
        setupLoader()
        setupViewModel()
    }
}

// MARK: - Setup Methods
private extension MovieListVC {
    
    func setupCollectionView() {
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        setupSearchPublisher()
    }
    
    func setupLoader() {
        loaderView.center = view.center
        loaderView.hidesWhenStopped = true
        view.addSubview(loaderView)
    }
    
    func setupViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.showLoader() : self?.hideLoader()
            }
            .store(in: &cancellables)

        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }

        viewModel.fetchMovies()
    }
    
    func setupSearchPublisher() {
        searchBar.searchTextField
            .publisher(for: \.text)
            .compactMap { $0 }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) // Reduce API calls
            .removeDuplicates()
            .sink { [weak self] query in
                self?.viewModel.searchMovies(with: query)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Loader Methods
private extension MovieListVC {
    
    func showLoader() {
        loaderView.startAnimating()
    }
    
    func hideLoader() {
        loaderView.stopAnimating()
    }
}

// MARK: - UISearchBarDelegate
extension MovieListVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(with: searchText)
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = viewModel.filteredMovies.count
        if count == 0 {
               collectionView.setEmptyMessage("No Data Found")
           } else {
               collectionView.restore()
           }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesListCell", for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: viewModel.filteredMovies[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MovieListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = spacing * (numberOfItemsPerRow + 1)
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth * 1.8)
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailVC") as? MovieDetailVC {
            detailVC.movie = viewModel.filteredMovies[indexPath.row]
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
