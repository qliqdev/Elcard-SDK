import { registerPlugin } from '@capacitor/core';

import type { ElcartSDKPlugin } from './definitions';

const ElcartSDK = registerPlugin<ElcartSDKPlugin>('ElcartSDK', {
  web: () => import('./web').then(m => new m.ElcartSDKWeb()),
});

export * from './definitions';
export { ElcartSDK };
