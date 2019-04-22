//
//  TemplatesLoader.swift
//  Jimbo
//
//  Created by Alexander Polovinka on 4/17/19.
//  Copyright © 2019 Jimbo. All rights reserved.
//

import Foundation
import RealmSwift

class TemplatesList: RealmObservableList<TemplateRM> {

    let service: TemplatesService!

    required init(service: TemplatesService) {
        self.service = service
        super.init(configurationHandler: {
            return DataStackRM.realm.objects(TemplateRM.self).sorted(byKeyPath: "orderIndex")
        })
    }

}
