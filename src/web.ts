import { WebPlugin } from '@capacitor/core';

import type { ElcartSDKPlugin } from './definitions';

export class ElcartSDKWeb extends WebPlugin implements ElcartSDKPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
