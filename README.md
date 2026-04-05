# WeCamino
WeCamino es una app móvil pensada para peregrinos del Camino de Santiago que quieren mantenerse conectados durante la ruta, compartir su progreso y vivir la experiencia de forma más social.

## Git workflow

Este repositorio sigue una variante simple de Git Flow.

### Main branches

- `master`: rama protegida y estable. Solo debe contener código listo para producción.
- `develop`: rama de integración del equipo. Aquí se unen las features antes de preparar una release.

### Supporting branches

- `feature/<nombre-corto>`: para desarrollo de funcionalidades.
- `release/<version>`: para estabilización y preparación de una versión.
- `hotfix/<nombre-corto>`: para correcciones urgentes sobre producción.

### Recommended flow

1. Crear una rama desde `develop` para cada tarea:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/nombre-de-la-tarea
```

2. Abrir Pull Request hacia `develop` al terminar la implementación.
3. Crear una rama `release/<version>` desde `develop` cuando se vaya a cerrar una versión.
4. Fusionar la release en `master` y también de vuelta en `develop`.
5. Crear `hotfix/<nombre-corto>` desde `master` solo para incidencias críticas en producción.
6. Fusionar cada hotfix en `master` y `develop`.

### Merge policy

- No trabajar directamente sobre `master`.
- No hacer push directo a `master`.
- Priorizar Pull Requests con revisión antes de mergear.
- Mantener `develop` siempre en un estado integrable.
- Usar merge commit o squash según la política del repositorio, pero de forma consistente.
