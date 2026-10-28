
// ArtDoViewModel.swift - إدارة مراحل نشاط الفن Do.
//
// Contains:
// - Activity data.
// - Ready, collecting, and reflecting stages.
// - Methods for moving between stages.
//
// Used by: ArtDoView.
// Learn: @Observable, enum, functions.

import Foundation
import Observation

// MARK: - Activity Stages

enum ArtDoStage {
    case ready
    case collecting
    case reflecting
    case completed
}

// MARK: - Art Do ViewModel

@MainActor
@Observable
final class ArtDoViewModel {

    // بيانات نشاط غروب الشمس
    let activity = ArtDoModel.sunset

    // المرحلة الحالية
    private(set) var stage: ArtDoStage = .ready

    // MARK: - Start

    // بدء جمع العناصر وترتيبها
    func startActivity() {

        guard stage == .ready else {
            return
        }

        stage = .collecting
    }

    // MARK: - Reflection

    // الانتقال إلى مرحلة التأمل
    func startReflection() {

        guard stage == .collecting else {
            return
        }

        stage = .reflecting
    }

    // MARK: - Finish

    // اكتمال النشاط
    func finishActivity() {

        guard stage == .reflecting else {
            return
        }

        stage = .completed
    }
}
