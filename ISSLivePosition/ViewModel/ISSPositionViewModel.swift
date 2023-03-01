//
//  ISSPositionViewModel.swift
//  ISSLivePosition
//
//  Created by Nagraj on 2/25/23.
//

import Foundation

class ISSPositionViewModel {
    private var connectionManager = ConnectionManager()
    var position: ISSPosition?
    
    /// Fetch the ISS live position
    func fetchISSLivePosition(completion: @escaping () -> ()) {
        connectionManager.retrieveISSPosition {issPosition, error in
            self.position = issPosition
            completion()
        }
    }
}
