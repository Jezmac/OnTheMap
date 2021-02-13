//
//  StudentLocationViewModel.swift
//  OnTheMap
//
//  Created by Jeremy MacLeod on 13/02/2021.
//

import UIKit

protocol StudentLocationViewModelDelegate: class {
    func onFetchFailed(with reason: String)
}

class StudentLocationViewModel {
    private weak var delegate: StudentLocationViewModelDelegate?
    
    private var students: [StudentLocation] = []
    private var selectedIndex = 0
    private var total = 0
    
    init(delegate: StudentLocationViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    func student(at index: Int) -> StudentLocation {
        return students[index]
    }
    
    func getStudentLocations() {
        UdacityClient.getStudentLocations { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.onFetchFailed(with: error.localizedDescription)
            case .success(let response):
                self?.students = response
            }
        }
    }
}
