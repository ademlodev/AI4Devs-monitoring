IDE: VSCode
IA: Claude sonnet 3.5

Prompt1: revisa todo el código generado con terraform en la carpeta @tf para asegurar que tenemos preparada la integración de DataDog con AWS usando Terraform

Me genera el primer commit con los cambios en terraform para añadir variables y providers
También genera datadog.tf para realizar la integración.

Con esto pruebo el despliegue en AWS con el CI del anterior practica.

Me queda pendiente ver como integro eso con el monitoring de Datadog
