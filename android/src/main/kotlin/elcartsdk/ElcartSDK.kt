package elcartsdk

import android.os.Bundle
import android.util.Log
import com.getcapacitor.Bridge
import com.getcapacitor.JSObject
import com.getcapacitor.PluginCall
import com.ipc.elcard.tokenize.api.ElcardAPI
import com.ipc.elcard.tokenize.api.ElcardCodes
import com.ipc.elcard.tokenize.api.ElcardResultCallback

class ElcartSDK(private val bridge: Bridge): ElcardResultCallback {
    private var tag: String = "ElcartSDK";
    private var call: PluginCall? = null;

    fun bindCard(call: PluginCall) {
        this.call = call;
        ElcardAPI.bindCard(bridge.context, this)
    }

    override fun onResult(code: Long, data: Bundle, reason: Throwable?) {
        when (code) {
            ElcardCodes.ERROR_OK -> {
                val ret = JSObject()
                ret.put("code", code)
                ret.put("data", data.getString("card_data"))
                call?.resolve(ret)
                Log.d(
                        tag,
                        String.format("Code %d, data %s", code, data.getString("card_data"))
                )
            }
            ElcardCodes.ERROR_CANCELLED -> {
                call?.reject("Cancelled","CANCELLED")
                Log.d(
                        tag,
                        String.format("Code %d, reason %s", code, reason?.localizedMessage)
                )
            }
            else -> {
                call?.reject(reason?.localizedMessage,"ERROR")
                Log.d(
                        tag,
                        String.format("Code %d, reason %s", code, reason?.localizedMessage)
                )
            }
        }
    }
}