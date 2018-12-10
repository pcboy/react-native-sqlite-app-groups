import { NativeModules } from 'react-native';

const { RNSQLiteAG } = NativeModules;

class SQLiteAG { 
  constructor(appGroupKey, dbPath) {
    this.appGroupKey = appGroupKey;
    this.dbPath = dbPath;
  }

  static init(_appGroupKey, _dbPath) {
    return Promise.resolve(new SQLiteAG(_appGroupKey, _dbPath));
  }

  exec(query) {
    return new Promise((resolve, reject) => {
       RNSQLiteAG.exec(this.appGroupKey, this.dbPath, query, (value) => {
        resolve(this)
      }, (error) => reject(error))
    })
  }
}

export default SQLiteAG;
