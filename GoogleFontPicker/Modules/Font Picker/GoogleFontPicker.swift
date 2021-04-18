//
//  GoogleFontPicker.swift
//  GoogleFontPicker
//
//  Created by Greener Chen on 2021/4/16.
//

import UIKit
import Combine

class GoogleFontPicker: UIViewController, ObservableObject, Identifiable {
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    // MARK: - Properties
    private weak var fontStore = FontManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
                                    collectionViewLayout: GoogleFontPicker.collectionViewLayout())
        view.register(GoogleFontCell.self, forCellWithReuseIdentifier: GoogleFontCell.reuseId())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @Published var previewText: String = ""
    
    var selectedFont = PassthroughSubject<UIFont, Never>()
}

// MARK: - Setup UI
extension GoogleFontPicker {
    class func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Data source
extension GoogleFontPicker: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fontStore?.webfonts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GoogleFontCell = collectionView.dequeueReusableCell(withReuseIdentifier: GoogleFontCell.reuseId(), for: indexPath) as! GoogleFontCell
        
        if let webfont = fontStore?.webfonts[indexPath.item] {
            cell.nameLabel.text = webfont.family
            
            $previewText
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .assign(to: \.text, on: cell.previewLabel)
                .store(in: &cancellables)
            
            let sharedWebFont = fontStore?.getFont(webfont)
                .receive(on: DispatchQueue.main)
                .sink { (completion) in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                } receiveValue: { (font) in
                    cell.nameLabel.text = font.fontName
                    cell.nameLabel.font = font.withSize(10)
                    cell.previewLabel.font = font.withSize(34)
                }
                .store(in: &cancellables)
        }
        
        return cell
    }
}

extension GoogleFontPicker: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        do {
            if let webfont = fontStore?.webfonts[indexPath.item],
               let font = try fontStore?.getLocalFont(of: webfont) {
                selectedFont.send(font)
            }
        } catch {
            print(error)
        }
    }
}

