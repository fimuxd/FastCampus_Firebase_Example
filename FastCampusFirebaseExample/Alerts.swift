//
//  Alerts.swift
//  FastCampusFirebaseExample
//
//  Created by Boyoung Park on 22/04/2019.
//  Copyright © 2019 Boyoung Park. All rights reserved.
//

import UIKit

enum AlertType {
    case invalidUser
    case submitFailed(error: Error?)
    case deleteFailed(error: Error?)
    case searchFailed(error: Error?)
    
    var title: String? {
        switch self {
        case .invalidUser:
            return "존재하지 않는 유저"
        case .submitFailed:
            return "입력 실패"
        case .deleteFailed:
            return "삭제 실패"
        case .searchFailed:
            return "조회 실패"
        }
    }
    
    var message: String? {
        switch self {
        case .invalidUser:
            return "해당 이름을 가진 사용자가 없습니다."
        case let .submitFailed(error),
             let .deleteFailed(error),
             let .searchFailed(error):
            return """
            데이터 불러오기에 실패했습니다. 네트워크 환경 확인 후 재시도 해주세요.
            참고: \(error?.localizedDescription ?? "없음")
            """
        }
    }
}

func presentAlert(base: UIViewController?, type: AlertType) {
    let alertViewController = UIAlertController(
        title: type.title,
        message: type.message,
        preferredStyle: .alert
    )
    
    let alertAction = UIAlertAction(
        title: "확인",
        style: .default,
        handler: nil
    )
    
    alertViewController.addAction(alertAction)
    base?.present(alertViewController, animated: true, completion: nil)
}
