//
//  NetflixFilterBarView.swift
//  SwiftUI-Clones
//
//  Created by Vuk Knezevic on 11.04.24.
//

import SwiftUI

struct FilterModel: Hashable, Equatable {
    let title: String
    let isDropdown: Bool
    
    static var mockArray: [FilterModel] {
        [
            FilterModel(title: "TV Shows", isDropdown: false),
            FilterModel(title: "Movies", isDropdown: false),
            FilterModel(title: "Categories", isDropdown: true)
        ]
    }
}

struct NetflixFilterBarView: View {
    
    var filters: [FilterModel] = FilterModel.mockArray
    var selectedFitler: FilterModel? = nil
    // MARK: - selectedFitler je mogao biti i @Binding kao @Binding var selection: String unutar BumbleFilterView-a. Razlika je u tome sto @Binding odmah obavestava parenta o izmeni, a ovde radim preko callbacka jer neki put, kao ovde, UI ima jos zadataka da obavi pre nego sto obavesti parenta o izmeni
    
    var onXmarkPressed: (() -> Void)? = nil
    var onFilterPressed: ((FilterModel) -> Void)? = nil
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if selectedFitler != nil {
                    Image(systemName: "xmark")
                        .padding(8)
                        .background {
                            Circle()
                                .stroke(lineWidth: 1.0)
                        }
                        .foregroundStyle(.netflixLightGray)
                        .background(Color.blue.opacity(0.001))
                        .onTapGesture {
                            onXmarkPressed?()
                        }
                    // pojavljivanje X buttona sa leve strane ekrana
                        .transition(AnyTransition.move(edge: .leading))
                        .padding(.leading, 16)
                }
                
                
                ForEach(filters, id: \.self) { filter in
                    // uslov da samo odabrana celija bude prikazana
                    if selectedFitler == nil || selectedFitler == filter {
                        NetflixFilterCell(
                            title: filter.title,
                            isDropdown: filter.isDropdown,
                            isSelected: selectedFitler == filter
                        )
                        .background(.blue.opacity(0.001))
                        .onTapGesture {
                            onFilterPressed?(filter)
                        }
                        .padding(.leading, ((selectedFitler == nil) && (filter == filters.first)) ? 16 : 0)
                    }
                    
                }
            }
            .padding(.vertical, 4)
        }
        .scrollIndicators(.hidden)
        .animation(.bouncy, value: selectedFitler)
    }
}

fileprivate struct NetflixFilterBarViewPreview: View {
    
    @State private var filters = FilterModel.mockArray
    @State private var selectedFitler: FilterModel? = nil
    
    var body: some View {
        NetflixFilterBarView(
            filters: filters ,
            selectedFitler: selectedFitler) {
                selectedFitler = nil
            } onFilterPressed: { newFilter in
                selectedFitler = newFilter
            }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        NetflixFilterBarViewPreview()
            .padding(.leading, 16)
    }
}
