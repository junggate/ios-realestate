//
//  ReamBase.swift
//  realreview-iOS
//
//  Created by JungMoon-Mac on 2018. 4. 18..
//  Copyright © 2018년 JungMoon. All rights reserved.
//

import RealmSwift

class RealmManager: NSObject {
    //############ Database Version Setting ############

    let currentVersion: UInt64 = 1

    //##################################################

    static let sharedInstance = RealmManager()
    var realm: Realm!

    override init() {
        super.init()

        let fileName = "Realm_v\(currentVersion).realm"
        let documentsPath = "\(NSHomeDirectory())/Documents/"
        let fileUrl = URL.init(fileURLWithPath: "\(documentsPath)\(fileName)")
        print("💾 Documents Path :\n\(fileUrl.absoluteString)")
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: currentVersion,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { _, oldSchemaVersion in
                print("DB Update!! oldVersion:\(oldSchemaVersion) newVersion:\(self.currentVersion)")
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if oldSchemaVersion < self.currentVersion {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        config.fileURL = fileUrl
        Realm.Configuration.defaultConfiguration = config
        do {
            realm = try Realm()
        } catch {
            print("'try Realm()' is fail.")
        }
    }

    /// 데이터를 삽입합니다.
    ///
    /// - Parameter objects: Managed Object
    func insert(_ objects: Object...) {
        beginWrite()

        for object in objects {
            realm.add(object)
        }
    }

    /// 전체 데이터 조회
    ///
    /// - Parameter type: Managed Object
    /// - Returns: 조회 결과
    func select<T: Object>(_ type: T.Type) -> Results<T> {
        let result = realm.objects(type)
        return result
    }

    /// 전체 데이터 조회
    ///
    /// - Parameters:
    ///   - type: Managed Object
    ///   - format: 조회 조건
    /// - Returns: 조회 결과
    func select<T: Object>(_ type: T.Type, filter format: String!) -> Results<T> {
        let result = realm.objects(type).filter(format)
        return result
    }

    /// 데이터를 삭제합니다.
    ///
    /// - Parameter objects: Managed Object
    func delete(_ objects: [Object]) {
        beginWrite()
        realm.delete(objects)
    }

    func delete(_ objects: Object...) {
        beginWrite()
        for object in objects {
            realm.delete(object)
        }
    }

    /// 테이블의 데이터를 삭제한다.
    ///
    /// - Parameter type: 해당 객체
    func deleteAll<T: Object>(_ type: T.Type) {
        beginWrite()
        let result = realm.objects(type)
        realm.delete(result)
    }

    /// Realm 모든 데이터 삭제
    func deleteRealm() {
        beginWrite()
        realm.deleteAll()
        save()
    }

    func beginWrite() {
        if realm.isInWriteTransaction == false {
            realm.beginWrite()
        }
    }

    /// 변경 사항 저장
    func save() {
        do {
            try realm.commitWrite()
        } catch {
            print("'try realm.commitWrite()' is fail.")
        }
    }

    /// 변경사항 되돌림
    func revoke() {
        realm.cancelWrite()
    }
}
