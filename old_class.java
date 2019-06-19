public class ClassName extends Main {

    public DVHABCProjectAppModuleImpl getDVHAbcProjectAppModuleImpl() {
        return (DVHABCProjectAppModuleImpl) hMap.get("am");
    }

    public DVHUtilsAppModuleImpl getDVHUtilsAppModuleImpl() {
        return (DVHUtilsAppModuleImpl) hMap.get("amDvhUtils");
    }
}