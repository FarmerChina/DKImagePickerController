//
//  DKImageExtensionInlineCamera.swift
//  DKImagePickerController
//
//  Created by ZhangAo on 16/12/2017.
//  Copyright © 2017 ZhangAo. All rights reserved.
//

import Foundation
import DKCamera

class DKImageExtensionInlineCamera: DKImageBaseExtension {
    
    override class func extensionType() -> DKImageExtensionType {
        return .inlineCamera
    }
        
    override func perform(with extraInfo: [AnyHashable: Any]) {
        guard let didFinishCapturingImage = extraInfo["didFinishCapturingImage"] as? ((UIImage, [AnyHashable : Any]?) -> Void)
            , let didCancel = extraInfo["didCancel"] as? (() -> Void) else { return }
        
        let camera = DKCamera()
        camera.didFinishCapturingImage = didFinishCapturingImage
        camera.didCancel = didCancel
        
        self.checkCameraPermission(camera)
        
        if (camera as UIViewController) is UINavigationController {
            self.context.imagePickerController.present(camera, animated: true)
            self.context.imagePickerController.setViewControllers([], animated: false)
        } else {
            self.context.imagePickerController.setViewControllers([camera], animated: false)
        }
    }

    override func finish() {
        self.context.imagePickerController.dismiss(animated: true)
    }

    // MARK: - Private
    
    private func checkCameraPermission(_ camera: DKCamera) {
        func cameraDenied() {
            DispatchQueue.main.async {
                let permissionView = DKPermissionView.permissionView(.camera)
                camera.cameraOverlayView = permissionView
            }
        }
        
        func setup() {
            camera.cameraOverlayView = nil
        }
        
        DKCamera.checkCameraPermission { granted in
            granted ? setup() : cameraDenied()
        }
    }
    
}
