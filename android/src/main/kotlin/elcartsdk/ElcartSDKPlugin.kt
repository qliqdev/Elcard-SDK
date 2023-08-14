package elcartsdk

import com.getcapacitor.Plugin
import com.getcapacitor.annotation.CapacitorPlugin
import com.getcapacitor.PluginMethod
import com.getcapacitor.PluginCall

@CapacitorPlugin(name = "ElcartSDK")
class ElcartSDKPlugin : Plugin() {
    private var implementation: ElcartSDK? = null

    override fun load() {
        implementation = ElcartSDK(bridge)
    }

    @PluginMethod
    fun bindCard(call: PluginCall) {
        implementation!!.bindCard(call)
    }
}