//
//  PermissionScreen.swift
//  Notes
//
//  Created by Muhammad Khubaib Imtiaz on 01/01/2025.
//

import SwiftUI
import AVFoundation

struct PermissionScreen: View {
    
    @State var cameraPermission: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
    @State var cameraPermissionText: String =  "Allow Camera"
    @State var photosPermissionText: String = "Allow Photos"
    @State var locationPermissionText: String = "Allow Location"
    
    @AppStorage("isPermissionGranted") private var isPermissionGranted = false
    
    var body: some View {
        VStack(alignment: .center, spacing: CGFloat(6)) {
            Image("notes")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("Please allow Notes to access your Camera, Photos, and Location.")
                .padding(.all)
                .frame(alignment: .center)
            
            
        
            Button {
                requestCameraPermission()
               if cameraPermission == .authorized {
                    //isPermissionGranted = true
                    cameraPermissionText = "Camera Permission Granted"
                } else {
                    cameraPermissionText = "Allow Camera"
                }
            } label: {
                Label("\(cameraPermissionText)", systemImage: "camera")
            }

            Button {
                
            } label: {
                Label("Allow Photos", systemImage: "photo")
            }
            
            Button {
                
            } label: {
                Label("Allow Location", systemImage: "location")
            }
        }.onAppear {
            cameraPermission = AVCaptureDevice.authorizationStatus(for: .video)
        }
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { isGranted in
            DispatchQueue.main.async {
                cameraPermission = AVCaptureDevice.authorizationStatus(for: .video)
            }
        }
    }
}
