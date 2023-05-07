import { WebPlugin } from '@capacitor/core';

import type { ElcartSDKPlugin } from './definitions';

export class ElcartSDKWeb extends WebPlugin implements ElcartSDKPlugin {
  async bindCard(): Promise<any> {
    throw this.unimplemented('ElcartSDK not implemented on Web')
  }
}
