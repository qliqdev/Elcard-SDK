export interface ElcartSDKPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
